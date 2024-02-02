resource "aws_s3_bucket" "example" {
  bucket = "dimitar-s3-bucket"
}

resource "aws_s3_object" "html_file" {

  key          = "index.html"
  source       = "/Users/dimitarrusev/PycharmProjects/pythonProject/dimitar-rusev-repo-01/index.html"
  content_type = "text/html"
  bucket       = aws_s3_bucket.example.id


}