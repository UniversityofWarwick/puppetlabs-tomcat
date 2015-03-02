
# Declares a Resource element to go inside conf/context.xml.
# You need to include the tomcat::config::context class to
# actually have this file managed and the resources defined.
define tomcat::config::context::resource (
  $catalina_base         = $::tomcat::catalina_home,
  $additional_attributes = {}
) {

  validate_hash($additional_attributes)

  $real_name = $name

  concat::fragment { "${catalina_base}-context-resource-${real_name}" :
    target  => "${catalina_base}/conf/context.xml",
    content => template("tomcat/resource.xml.erb"),
    order   => 500,
  }
}
