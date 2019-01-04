resource "aws_instance" "jenkins-instance" {
    ami = "${var.AMI_ID}"
    instance_type = "t2.small"
    subnet_id = "${aws_subnet.public-1a.id}"
    associate_public_ip_address = true
    vpc_security_group_ids = ["${aws_security_group.mocafi-utility-jenkins.id}"]
    key_name = "${aws_key_pair.jenkins-key.key_name}"
    user_data = "${data.template_cloudinit_config.cloudinit-jenkins.rendered}"
}

resource "aws_ebs_volume" "jenkins-data" {
    availability_zone = "us-east-1a"
    size = 50
    type = "gp2"
    tags {
        Name = "jenkins-data"
    }
}

resource "aws_volume_attachment" "jenkins-data-attachment" {
    device_name = "${var.INSTANCE_DEVICE_NAME}"
    volume_id = "${aws_ebs_volume.jenkins-data.id}"
    instance_id = "${aws_instance.jenkins-instance.id}"
    skip_destroy = true
}