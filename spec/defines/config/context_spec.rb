require 'spec_helper'

describe 'tomcat::config::context', :type => :define do
  let :pre_condition do
    'class { "tomcat": }'
  end
  let :facts do
    {
      :osfamily => 'Debian',
      :augeasversion => '1.0.0',
      :concat_basedir => '/tmp/noexist'
    }
  end
  let :title do
    'default'
  end
  context 'default' do
    it {
      should contain_concat__fragment('/opt/apache-tomcat-context-header').with({
        :target => '/opt/apache-tomcat/conf/context.xml',
        :order  => '0000'
      })
      should contain_concat__fragment('/opt/apache-tomcat-context-footer').with({
        :target => '/opt/apache-tomcat/conf/context.xml',
        :order  => '9999'
      })
      should contain_concat('/opt/apache-tomcat/conf/context.xml').with({
        :ensure => 'present'
      })
    }
  end
end
