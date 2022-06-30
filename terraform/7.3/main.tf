provider "yandex" {
	token = var.YCTOKEN
	cloud_id = "${var.yandex_cloud_id}"
	folder_id = "${var.yandex_folder_id}"
	zone = "${var.yandex_cloud_zone}"
}


