#------------------------------------------------------------------------------
# This is a workaround since Terraform and Helm provider are having (reported)
# issues with Bitnami
#------------------------------------------------------------------------------
resource "null_resource" "download" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = "curl -o external-dns-6.4.4.tgz -L https://charts.bitnami.com/bitnami/external-dns-6.4.4.tgz"
  }
}
#------------------------------------------------------------------------------
# External DNS (Private): Sync ingresses hosts with your DNS server.
#------------------------------------------------------------------------------
resource "helm_release" "externaldns_private" {
  count = var.enable_private_dns_sync ? 1 : 0

  depends_on = [null_resource.download]

  name      = "externaldns-private"
  namespace = kubernetes_namespace.externaldns[0].id
  #repository = "https://charts.bitnami.com/bitnami"
  chart   = "./external-dns-6.4.4.tgz"
  version = "6.4.4"
  values = [
    templatefile("chart-values/externaldns.yaml", {
      filteredDomain     = local.private_base_domain
      filteredZoneId     = data.terraform_remote_state.shared-dns.outputs.aws_internal_zone_id[0]
      txtOwnerId         = "${local.environment}-eks-demo-prv"
      annotationFilter   = "kubernetes.io/ingress.class=${local.private_ingress_class}"
      zoneType           = "private"
      serviceAccountName = "externaldns-private"
      roleArn            = data.terraform_remote_state.cluster-identities.outputs.private_externaldns_role_arn
    })
  ]
}

#------------------------------------------------------------------------------
# External DNS (Public): Sync ingresses hosts with your DNS server.
#------------------------------------------------------------------------------
resource "helm_release" "externaldns_public" {
  count = var.enable_public_dns_sync ? 1 : 0

  depends_on = [null_resource.download]

  name      = "externaldns-public"
  namespace = kubernetes_namespace.externaldns[0].id
  #repository = "https://charts.bitnami.com/bitnami"
  chart   = "./external-dns-6.4.4.tgz"
  version = "6.4.4"
  values = [
    templatefile("chart-values/externaldns.yaml", {
      filteredDomain     = local.public_base_domain
      filteredZoneId     = data.terraform_remote_state.shared-dns.outputs.aws_public_zone_id[0]
      txtOwnerId         = "${local.environment}-eks-demo-pub"
      annotationFilter   = "kubernetes.io/ingress.class=${local.public_ingress_class}"
      zoneType           = "public"
      serviceAccountName = "externaldns-public"
      roleArn            = data.terraform_remote_state.cluster-identities.outputs.public_externaldns_role_arn
    })
  ]
}
