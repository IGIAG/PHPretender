# 🚀 PHPretender Project

## ❓ What is this?

This project allows you to build **Web APIs** and **SSR Webapps** using any compiled programming language and deploy them to **shared web hosting** (e.g., Hostinger). 🌐

## ⚙️ How does it work?

The `index.php` file acts as a bridge between PHP and your binary. Here's how it works:

1. 📨 When a request is received, the PHP script serializes it as JSON and runs your binary.
2. 🔄 The request is passed into `stdin`, and the script waits for a response.
3. 📤 The response is received via `stdout`, parsed as JSON, and sent back to the user.

### 📥 What the binary receives:
```json
{
  "path": "/",
  "method": "GET",
  "query": {},
  "post": {},
  "body": "",
  "headers": {
    "Host": "localhost:8081",
    "User-Agent": "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:137.0) Gecko/20100101 Firefox/137.0",
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
    "Accept-Language": "en-US,en;q=0.5",
    "Accept-Encoding": "gzip, deflate, br, zstd",
    "Connection": "keep-alive",
    "Upgrade-Insecure-Requests": "1",
    "Sec-Fetch-Dest": "document",
    "Sec-Fetch-Mode": "navigate",
    "Sec-Fetch-Site": "none",
    "Sec-Fetch-User": "?1",
    "Priority": "u=0, i"
  }
}
```

### 📤 What it should send back:
```json
{
  "status": 200,
  "headers": {
    "X-Powered-By": "Dlang-Server",
    "Content-Type": "application/json"
  },
  "body": "{\"city\":\"Warsaw\",\"temperatureCelsious\":39.78097,\"temperatureFahrenheit\":103.60575}"
}
```

### 🛠️ Example Implementation

An example implementation in **Dlang** can be found under `/serverd`.

## ⚠️ IMPORTANT

- 🔒 **Ensure that the binary and its source code are protected and cannot be accessed directly.**
- ✅ Your PHP server must allow `proc_open()`.
- ⚡ This is just something I vibe-coded in an afternoon. **Not recommended for production use.**

## 🤝 Contributions

Contributions are welcome! Feel free to open issues or submit pull requests to improve this project. 💡
