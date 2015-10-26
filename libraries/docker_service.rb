module DockerCookbook
  class DockerService < DockerServiceBase

    use_automatic_resource_name

    # register with the resource resolution system
    provides :docker_service

    # installation type and service_manager
    property :install_method, %w(binary script package none auto), default: 'binary', desired_state: false
    property :service_manager, %w(execute sysvinit upstart systemd auto), default: 'auto', desired_state: false

    #########
    # Actions
    #########

    action :create do
      property_def = proc do
        # used by binary install
        source new_resource.source if new_resource.source
        checksum new_resource.checksum if new_resource.checksum
        version new_resource.version if new_resource.version
        # used by script install
        repo new_resource.repo if new_resource.repo
        script_url new_resource.script_url if new_resource.script_url
        action :create
        notifies :restart, new_resource
      end

      case install_method
      when 'auto'
        docker_installation(new_resource.instance, &property_def)
      when 'binary'
        docker_installation_binary(new_resource.instance, &property_def)
      when 'script'
        docker_installation_script(new_resource.instance, &property_def)
      when 'package'
        docker_installation_package(new_resource.instance, &property_def)
      when 'none'
        Chef::Log.info('Skipping Docker installation. Assuming it was handled previously.')
      end
    end

    action :delete do
      docker_installation 'default' do
        action :delete
      end
    end

    action :start do
      case service_manager
      when 'auto'
        docker_service_manager(new_resource.instance, &property_def)
      when 'execute'
        docker_service_manager_execute(new_resource.instance, &property_def)
      when 'sysvinit'
        docker_service_manager_sysvinit(new_resource.instance, &property_def)                
      when 'upstart'
        docker_service_manager_upstart(new_resource.instance, &property_def)
      when 'systemd'
        docker_service_manager_systemd(new_resource.instance, &property_def)
      end
    end

    action :stop do
      docker_service_manager 'default' do
        action :stop
      end
    end

    action :restart do
      docker_service_manager 'default' do
        action :restart
      end
    end
    
  end
end

# Declare a module for subresoures' providers to sit in (backcompat)
class Chef
  class Provider
    module DockerService
    end
  end
end
