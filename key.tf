resource "aws_key_pair" "jenkins-key" {
    key_name = "jenkins-key"
    public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
}