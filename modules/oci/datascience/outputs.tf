output "oci_datascience_notebook_session_urls" {
  value = {
    for k, v in oci_datascience_notebook_session.default :
    k => v.notebook_session_url
  }
}
