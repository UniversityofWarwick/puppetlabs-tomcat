require 'spec_helper'

describe 'tomcat::config::context::resource', :type => :define do
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
    'jdbc/MainDb'
  end
  context 'default' do
    it {
      should contain_concat__fragment('/opt/apache-tomcat-context-resource-jdbc/MainDb').with({
        :target => '/opt/apache-tomcat/conf/context.xml'
      })
    }
  end
  context 'set all the things' do
    let :params do
      {
        :catalina_base         => '/opt/apache-tomcat/test',
        :additional_attributes => {
          'driverClass'     => 'oracle.jdbc.OracleDriver',
          'username'        => 'maindbtest',
          'password'        => 'secret',
          'url'             => 'jdbc:oracle:thin:dbhost:1666:sid',
          'validationQuery' => 'SELECT 1 FROM DUAL',
        }
      }
    end
    expected = <<-eos
  <Resource name="jdbc/MainDb"
    driverClass="oracle.jdbc.OracleDriver"
    username="maindbtest"
    password="secret"
    url="jdbc:oracle:thin:dbhost:1666:sid"
    validationQuery="SELECT 1 FROM DUAL"
  />
    eos
    it {
      should contain_concat__fragment('/opt/apache-tomcat/test-context-resource-jdbc/MainDb').with({
        :target => '/opt/apache-tomcat/test/conf/context.xml',
        :content => expected.rstrip.gsub(/  /, "\t")
      })
    }
  end
  describe 'failing tests' do
    context 'bad additional_attributes' do
      let :params do
        {
          :additional_attributes => 'foo'
        }
      end
      it do
        expect {
          is_expected.to compile
        }.to raise_error(Puppet::Error, /not a Hash/)
      end
    end
  end
end
