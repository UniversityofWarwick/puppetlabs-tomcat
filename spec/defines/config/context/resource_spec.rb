require 'spec_helper'

describe 'tomcat::config::context::resource', :type => :define do
  let :pre_condition do
    'class { "tomcat": }'
  end
  let :facts do
    {
      :osfamily => 'Debian',
      :augeasversion => '1.0.0'
    }
  end
  let :title do
    'jdbc/MainDb'
  end
  context 'default' do
    it { is_expected.to contain_augeas('/opt/apache-tomcat-context-resource-jdbc/MainDb').with(
      'lens'    => 'Xml.lns',
      'incl'    => '/opt/apache-tomcat/conf/context.xml',
      'changes' => 'set Context/Resource[#attribute/name=\'jdbc/MainDb\']/#attribute/name \'jdbc/MainDb\'',
    )
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
        },
        :attributes_to_remove  => ['testOnBorrow']
      }
    end
    it { is_expected.to contain_augeas('/opt/apache-tomcat/test-context-resource-jdbc/MainDb').with(
      'lens'    => 'Xml.lns',
      'incl'    => '/opt/apache-tomcat/test/conf/context.xml',
      'changes' => [
        'set Context/Resource[#attribute/name=\'jdbc/MainDb\']/#attribute/name \'jdbc/MainDb\'',
        'set Context/Resource[#attribute/name=\'jdbc/MainDb\']/#attribute/driverClass \'oracle.jdbc.OracleDriver\'',
        'set Context/Resource[#attribute/name=\'jdbc/MainDb\']/#attribute/username \'maindbtest\'',
        'set Context/Resource[#attribute/name=\'jdbc/MainDb\']/#attribute/password \'secret\'',
        'set Context/Resource[#attribute/name=\'jdbc/MainDb\']/#attribute/url \'jdbc:oracle:thin:dbhost:1666:sid\'',
        'set Context/Resource[#attribute/name=\'jdbc/MainDb\']/#attribute/validationQuery \'SELECT 1 FROM DUAL\'',
        'rm Context/Resource[#attribute/name=\'jdbc/MainDb\']/#attribute/testOnBorrow'
      ]
    )
    }
  end
  context 'remove the resource' do
    let :params do
      {
        :resource_ensure => 'false'
      }
    end
    it { is_expected.to contain_augeas('/opt/apache-tomcat-context-resource-jdbc/MainDb').with(
      'lens'    => 'Xml.lns',
      'incl'    => '/opt/apache-tomcat/conf/context.xml',
      'changes' => 'rm Context/Resource[#attribute/name=\'jdbc/MainDb\']',
    )
    }
  end
  describe 'failing tests' do
    context 'bad valve_ensure' do
      let :params do
        {
          :resource_ensure => 'foo'
        }
      end
      it do
        expect {
          is_expected.to compile
        }.to raise_error(Puppet::Error, /does not match/)
      end
    end
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
    context 'old augeas' do
      let :facts do
        {
          :osfamily      => 'Debian',
          :augeasversion => '0.10.0'
        }
      end
      it do
        expect {
          is_expected.to compile
        }.to raise_error(Puppet::Error, /configurations require Augeas/)
      end
    end
  end
end
