require 'spec_helper'

describe 'rally::db::sync' do

  shared_examples_for 'rally-dbsync' do

    it 'runs rally-manage db_sync' do
      is_expected.to contain_exec('rally-manage db_sync').with(
        :command     => 'rally-manage --config-file /etc/rally/rally.conf db create',
        :user        => 'root',
        :path        => '/usr/bin',
        :refreshonly => 'true',
        :try_sleep   => 5,
        :tries       => 10,
        :logoutput   => 'on_failure',
        :subscribe   => ['Anchor[rally::install::end]',
                         'Anchor[rally::config::end]',
                         'Anchor[rally::dbsync::begin]'],
        :notify      => 'Anchor[rally::dbsync::end]',
      )
    end

  describe "overriding extra_params" do
    let :params do
      {
        :extra_params => '--config-file /var/lib/rally/rally.conf',
      }
    end

    it {
      is_expected.to contain_exec('rally-manage db_sync').with(
        :command     => 'rally-manage --config-file /var/lib/rally/rally.conf db create',
        :user        => 'root',
        :path        => '/usr/bin',
        :refreshonly => 'true',
        :try_sleep   => 5,
        :tries       => 10,
        :logoutput   => 'on_failure',
        :subscribe   => ['Anchor[rally::install::end]',
                         'Anchor[rally::config::end]',
                         'Anchor[rally::dbsync::begin]'],
        :notify      => 'Anchor[rally::dbsync::end]',
      )
      }
    end

  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts({}))
      end

      it_configures 'rally-dbsync'
    end
  end

end
