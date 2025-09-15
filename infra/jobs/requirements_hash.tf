resource "local_file" "requirements_hash" {
  content  = filemd5("${path.root}/requirements.txt")
  filename = "${path.module}/requirements.hash"
}
