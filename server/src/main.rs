use std::fs;
use std::io::{Read, Write};
use std::net::TcpListener;
use std::path::{Path, PathBuf};

struct Config {
    port: u16,
    prefix: String,
}

fn parse_args() -> Config {
    let args: Vec<String> = std::env::args().collect();
    let mut port: u16 = 9090;
    let mut prefix = String::from("very-");

    let mut i = 1;
    while i < args.len() {
        match args[i].as_str() {
            "--port" | "-p" => {
                i += 1;
                if i < args.len() {
                    port = args[i].parse().unwrap_or_else(|_| {
                        eprintln!("Invalid port: {}", args[i]);
                        std::process::exit(1);
                    });
                }
            }
            "--prefix" => {
                i += 1;
                if i < args.len() {
                    prefix = args[i].clone();
                    if !prefix.ends_with('-') {
                        prefix.push('-');
                    }
                }
            }
            "--help" | "-h" => {
                println!("Usage: serve-local [OPTIONS]");
                println!();
                println!("Options:");
                println!("  -p, --port <PORT>      Port to listen on (default: 9090)");
                println!("  --prefix <PREFIX>      File prefix filter (default: very-)");
                println!("  -h, --help             Show this help");
                std::process::exit(0);
            }
            _ => {
                eprintln!("Unknown argument: {}", args[i]);
                std::process::exit(1);
            }
        }
        i += 1;
    }

    Config { port, prefix }
}

fn main() {
    let config = parse_args();
    let shared_dir = resolve_shared_dir();

    let listener =
        TcpListener::bind(format!("127.0.0.1:{}", config.port)).unwrap_or_else(|e| {
            eprintln!("Failed to bind to port {}: {}", config.port, e);
            std::process::exit(1);
        });

    println!(
        "Serving {}*.html from: {}",
        config.prefix,
        shared_dir.display()
    );
    println!("Listening on http://127.0.0.1:{}", config.port);
    println!();
    list_available_files(&shared_dir, config.port, &config.prefix);

    for stream in listener.incoming() {
        match stream {
            Ok(mut stream) => {
                let mut buf = [0u8; 4096];
                let n = stream.read(&mut buf).unwrap_or(0);
                let request = String::from_utf8_lossy(&buf[..n]);

                let path = request
                    .lines()
                    .next()
                    .and_then(|line| line.split_whitespace().nth(1))
                    .unwrap_or("/");

                let response = handle_request(path, &shared_dir, &config.prefix);
                let _ = stream.write_all(response.as_bytes());
            }
            Err(e) => eprintln!("Connection error: {}", e),
        }
    }
}

fn resolve_shared_dir() -> PathBuf {
    let exe_dir = std::env::current_exe()
        .ok()
        .and_then(|p| p.parent().map(|d| d.to_path_buf()));

    let candidates = [
        std::env::current_dir().ok().map(|d| d.join("shared")),
        std::env::current_dir()
            .ok()
            .map(|d| d.join("../shared").to_path_buf()),
        exe_dir.map(|d| d.join("../../shared")),
    ];

    for candidate in candidates.into_iter().flatten() {
        if candidate.is_dir() {
            return candidate.canonicalize().unwrap_or(candidate);
        }
    }

    eprintln!("Could not find shared/ directory. Run from the project root.");
    std::process::exit(1);
}

fn handle_request(path: &str, shared_dir: &Path, prefix: &str) -> String {
    if path == "/" {
        return index_page(shared_dir, prefix);
    }

    let decoded = percent_decode(path.trim_start_matches('/'));
    let filename = Path::new(&decoded)
        .file_name()
        .map(|f| f.to_string_lossy().to_string())
        .unwrap_or_default();

    if !filename.starts_with(prefix) || !filename.ends_with(".html") {
        return response_404();
    }

    if filename.contains("..") || filename.contains('/') || filename.contains('\\') {
        return response_404();
    }

    let file_path = shared_dir.join(&filename);
    match fs::read_to_string(&file_path) {
        Ok(content) => response_200_html(&content),
        Err(_) => response_404(),
    }
}

fn index_page(shared_dir: &Path, prefix: &str) -> String {
    let mut files = collect_files(shared_dir, prefix);
    files.sort();

    let links: String = files
        .iter()
        .map(|f| {
            let label = f
                .strip_prefix(prefix)
                .unwrap_or(f)
                .strip_suffix(".html")
                .unwrap_or(f);
            format!("      <li><a href=\"/{}\">{}</a></li>\n", f, label)
        })
        .collect();

    let html = format!(
        r#"<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Local Shared Documents</title>
  <style>
    body {{ font-family: system-ui, sans-serif; max-width: 600px; margin: 4rem auto; padding: 0 1rem; }}
    a {{ color: #0066cc; text-decoration: none; }}
    a:hover {{ text-decoration: underline; }}
    li {{ margin: 0.5rem 0; }}
  </style>
</head>
<body>
  <h1>Shared Documents</h1>
  <ul>
{}  </ul>
</body>
</html>"#,
        links
    );

    response_200_html(&html)
}

fn list_available_files(shared_dir: &Path, port: u16, prefix: &str) {
    let mut files = collect_files(shared_dir, prefix);
    files.sort();

    println!("Available files:");
    for f in &files {
        println!("  http://127.0.0.1:{}/{}", port, f);
    }
    println!();
}

fn collect_files(shared_dir: &Path, prefix: &str) -> Vec<String> {
    fs::read_dir(shared_dir)
        .into_iter()
        .flatten()
        .filter_map(|e| e.ok())
        .filter_map(|e| {
            let name = e.file_name().to_string_lossy().to_string();
            if name.starts_with(prefix) && name.ends_with(".html") {
                Some(name)
            } else {
                None
            }
        })
        .collect()
}

fn response_200_html(body: &str) -> String {
    format!(
        "HTTP/1.1 200 OK\r\nContent-Type: text/html; charset=utf-8\r\nContent-Length: {}\r\nConnection: close\r\n\r\n{}",
        body.len(),
        body
    )
}

fn response_404() -> String {
    let body = "<!DOCTYPE html><html><body><h1>404 Not Found</h1></body></html>";
    format!(
        "HTTP/1.1 404 Not Found\r\nContent-Type: text/html; charset=utf-8\r\nContent-Length: {}\r\nConnection: close\r\n\r\n{}",
        body.len(),
        body
    )
}

fn percent_decode(s: &str) -> String {
    let mut result = Vec::new();
    let bytes = s.as_bytes();
    let mut i = 0;
    while i < bytes.len() {
        if bytes[i] == b'%' && i + 2 < bytes.len() {
            if let Ok(byte) =
                u8::from_str_radix(&String::from_utf8_lossy(&bytes[i + 1..i + 3]), 16)
            {
                result.push(byte);
                i += 3;
                continue;
            }
        }
        result.push(bytes[i]);
        i += 1;
    }
    String::from_utf8_lossy(&result).to_string()
}
