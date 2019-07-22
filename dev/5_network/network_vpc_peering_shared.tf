#
# VPC Peering Connection with Share: Requester Side
#
# Consider 'destination_cidr_block' parameter will be the CIDR of the remote VPC/Subnets  (originator of the VPC
# peering request) and 'route_table_id' the route table ID to add the destination route to.
#
resource "aws_vpc_peering_connection" "with_shared_vpc" {
  peer_owner_id = "${var.shared_account_id}"
  peer_vpc_id   = "${var.shared_vpc_id}"
  vpc_id        = "${module.vpc.vpc_id}"
  auto_accept   = false

  //    tags = "${merge(map("side", "accepter"), ${local.tags}"
  tags = "${merge(map("Name", "requester-dev-to-shared"), local.tags)}"
}

#
# Update Route Tables to go through the VPC Peering Connection
#
resource "aws_route" "priv_route_table_1_to_shared_vpc" {
  route_table_id            = "${element(module.vpc.private_route_table_ids, 0)}"
  destination_cidr_block    = "${var.shared_vpc_cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.with_shared_vpc.id}"
}

resource "aws_route" "pub_route_table_1_to_shared_vpc" {
  route_table_id            = "${element(module.vpc.public_route_table_ids, 0)}"
  destination_cidr_block    = "${var.shared_vpc_cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.with_shared_vpc.id}"
}