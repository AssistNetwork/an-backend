require 'grape'
require 'rack/cors'

require_relative 'api_helpers'

require_relative '../../lib/an'

module AN

  class V1 < ::Grape::API
    helpers ApiHelpers
    prefix 'api'
    format :json
    version %w{ v1 }, using: :header, vendor: 'assist-network', format: :json

#    use Rack::Cors do
#      allow do
#        origins '*'
#        resource '*', headers: :any, methods: [:get, :post, :put, :delete]
#      end
#    end

    use Grape::Middleware::Logger

    use Rack::Session::Cookie, secret: ::AN.configuration.session_secret



    desc 'Returns current API version and environment.'
    get do
      tpath = Pathname(File.expand_path(File.dirname(__FILE__)) + '/../taxonomy/' )
      { version: 'v1', environment: ENV['RACK_ENV'] , taxonomy: File.mtime(tpath +'taxonomy.json')}
    end

    # testing
    resource :test do
      get do
=begin
        if params['HTTP_CONTENT_TYPE'] == 'application/json' then
          request_json = {
            verb: params["REQUEST_METHOD"],
            uri:  params["REQUEST_URI"],
            body: params["rack.input"].read,
            protcol: params["SERVER_PROTOCOL"],
            headers: Hash[params[].select {|k, v| k.start_with?("HTTP_") }.map {|k, v| [k[5..-1], v] }]
            }.to_json
          {200, {'Content-Type' => "application/json", 'Content-Length' => request_json.length.to_s}, [request_json]}
        else
          {200, {'Content-Type' => 'application/xml'}, {'<foo><bar>baz</bar></foo>'}}
        end
=end
      'tested'
      end
    end

    resource :taxonomy do
      get do
        tpath = Pathname(File.expand_path(File.dirname(__FILE__)) + '/../taxonomy/' )
        JSON.parse(File.read(tpath + 'taxonomy.json'))
      end
    end

    resource :login do
      params do
        requires :email, type: String, desc:'user login with email'
        requires :node, type: String, desc: 'Node ID'
      end
      desc 'login'
      get do
        #authenticate!
        begin
          node = Node[(params[:node])]
          if node.nil?
            {:error => 'Wrong node ID'}
          else
            user = User[(params[:email])]
            {:succes => true, :name => user.name, :auth_token => user.auth_token}
          end
        end
      end

    end


    # AN COM handling
    resource :com do

      desc 'COM pingpong'
      get :test do
        { ping: 'pong'}
      end

      desc 'Receive AN messages in batch'
      params do
        requires :service, type: String, desc:'Assist-Network, Default:an'
        requires :node, type: String, desc: 'Node ID'
        requires :msg, type: Array, desc: 'Messages'
      end
      post do
        #authenticate!
        begin
          node = Node[(params[:node])]
          if node.nil?
            {:error => 'Wrong node ID'}
          else
            resp = Array.new
            msg = params[:msg]
            msg.each do |m|
              begin
 #               logger.info m.to_s
                clazz = Object.const_get(cmd_type(m.cmd))
              rescue NameError
                  {:error => 'Wrong object type'}
              end
              if clazz.nil? or !clazz.ancestors.include?(Ohm::Model)
                #p clazz.nil?
                #p clazz.ancestors.include? Ohm::Model
                {:error => 'ModelError: Wrong object model'}
              end
              rescue_db_errors {
                if !m.content.msgid.nil?
                  object = clazz[m.content.msgid]
                  if object.nil?
                    object = clazz.create(m.content)
                    object.node = node
                    object.save
                    resp.push({:object => m.cmd + object.msgid.to_s, :state => 'created'})
                  else
                    object.update( m.content )
                    resp.push({:object => m.cmd + object.msgid.to_s, :state => 'updated'})
                  end
                else
                  resp.push({:error => 'MSGID Error: Null identifier', :state => 'null'})
                end
              }
            end
            { :result => resp , :success => true }
          end
        end
      end

      desc 'Response AN objects in batch'
      params do
        requires :service, type: String, desc:'Assist-Network, Default:an'
        requires :node, type: String, desc: 'Node ID'
        requires :query, type: Hash, desc: 'Query'
        optional :page_num, type: Numeric, desc: 'Paginate page number'
        optional :limit, type: Numeric, desc: 'Paginate limit on page'
      end
      get do
        begin
          node = Node[(params[:node])]
          if node.nil?
            {:error => 'Wrong node ID'}
          else
            resp = Array.new
            q = params[:query]
            begin
              # logger.info m.to_s
              clazz = Object.const_get(cmd_type(q.type))
            rescue NameError
              {:error => 'Wrong object type'}
            end
            if clazz.nil? or !clazz.ancestors.include?(Ohm::Model)
              {:error => 'ModelError: Wrong object model'}
            end
            rescue_db_errors {
              if q.filter.msgid.nil?
                resp.push({:error => 'MSGID Error or Not Found', :success => false})
              else
                result = Array.new # TODO befejezni
                result = clazz.find(:msgid => q.filter.msgid) # TODO Lista kezelés
                unless result.nil?
#                  resp.push({:result => result.each {|r| r.to_hash }, :success => true}) # Paginate nélkül
                  resp.push({:result => paginate(result, params[:page_num], params[:limit]), :success => true})
                else
                  resp.push({:result => {}, :success => true})
                end

              end
              }
            resp
          end
        end
      end
    end

=begin
      desc 'Return a Message'
      params do
        requires :network, type: String, desc:'Assist-Network, Default:an'
        requires :node, type: Integer, desc: 'AN-Node ID'
        requires :cmd, type: String, desc: 'AN-Command'
        requires :msgid, type: Integer, desc: 'MSG _id'
      end
      route_param :msg_id do
        get do
          #authenticate!
          begin
            clazz = Object.const_get(cmd_type(params[:cmd]))
          rescue NameError
            {:error => 'Wrong object type'}
          end
          if clazz.nil? or !clazz.ancestors.include? Ohm::Model
            {:error => 'Wrong object type'}
          else
            object = clazz[params[:msg_id]]
            if object.nil?
              {:error => 'Object not found'}
            else
              object.to_hash
            end
          end
        end
      end
    end

      desc 'List a MSG'
      params do
        requires :network, type: String, desc:'Assist-Network, Default:an'
        requires :node, type: Integer, desc: 'AN-Node ID'
        optional :cmd, type: String, desc: 'AN-Command'
        optional :query, type: String, desc: 'Filter'
        optional :page, type: Integer, desc: 'Page num'
        optional :limit, type: Integer, desc: 'Page size'
      end
      post do
        #authenticate!
        begin
          clazz = Object.const_get(params[cmd_type(:cmd)])
        rescue NameError
          {:error => 'Wrong object type'}
        end
        if clazz.nil? or !clazz.ancestors.include? Ohm::Model
          {:error => 'Wrong object type'}
        else
          set = clazz.all # TODO query filtering
          paginate(set, params[:page], params[:limit])
        end
      end


      desc 'Create/Update an object'
      params do
        requires :type, type: String, desc: 'Object type'
        requires :object, type: Hash, desc: 'Object'
      end
      post do
        authenticate!
        begin
          #p Object.instance_method(:inspect).bind('Color').call
          clazz = Object.const_get(params[:type])
          clazz.ancestors.each do |i|
            p i.to_s
          end
        rescue NameError
          {:error => "NameError: Wrong constant name #{params[:type].to_s}" }
        rescue TypeError
          {:error => 'TypeError: Wrong object type'}
        end
        if clazz.nil? or !clazz.ancestors.include?(Ohm::Model)
          #p clazz.nil?
          #p clazz.ancestors.include? Ohm::Model
          {:error => 'ModelError: Wrong object model'}
        end
        rescue_db_errors {
          if !params[:object][:object_id].nil?
            ojects = clazz.find(_id: params[:object][:object_id])
            if ojects.count == 0
              {:error => 'ObjectID Error: Wrong object identifier'}
            else
              object = ojects.first
              object.update(params[:object])
            end
          else
            object = clazz.create(params[:object])
            object.save
          end
          {:object => object.to_hash, :success => true}
        }
      end

    end

    # Object handling
    resource :object do

      get do
        { ping: 'pong'}
      end

      desc 'Return list of objects'
      params do
        requires :type, type: String, desc: 'Object type'
        optional :page, type: Integer, desc: 'Page num'
        optional :limit, type: Integer, desc: 'Page size'
      end
      get :list do
        authenticate!
        begin
          clazz = Object.const_get(params[:type])
        rescue NameError
          {:error => 'Wrong object type'}
        end
        if clazz.nil? or !clazz.ancestors.include? Ohm::Model
          {:error => 'Wrong object type'}
        else
          set = clazz.all
          paginate(set, params[:page], params[:limit])
        end
      end

      desc 'Return an object'
      params do
        requires :type, type: String, desc: 'Object type'
        requires :object_id, type: Integer, desc: 'Object _id'
      end
      route_param :object_id do
        get do
          authenticate!
          begin
            clazz = Object.const_get(params[:type])
          rescue NameError
            {:error => 'Wrong object type'}
          end
          if clazz.nil? or !clazz.ancestors.include? Ohm::Model
            {:error => 'Wrong object type'}
          else
            object = clazz[params[:object_id]]
            if object.nil?
              {:error => 'Object not found'}
            else
              object.to_hash
            end
          end
        end
      end

      desc 'Create/Update an object'
      params do
        requires :type, type: String, desc: 'Object type'
        requires :object, type: Hash, desc: 'Object'
      end
      post do
        authenticate!
        begin
          #p Object.instance_method(:inspect).bind('Color').call
          clazz = Object.const_get(params[:type])
          clazz.ancestors.each do |i|
            p i.to_s
          end
        rescue NameError
          {:error => "NameError: Wrong constant name #{params[:type].to_s}" }
        rescue TypeError
          {:error => 'TypeError: Wrong object type'}
        end
        if clazz.nil? or !clazz.ancestors.include?(Ohm::Model)
          #p clazz.nil?
          #p clazz.ancestors.include? Ohm::Model
          {:error => 'ModelError: Wrong object model'}
        end
        rescue_db_errors {
          if !params[:object][:object_id].nil?
            ojects = clazz.find(_id: params[:object][:object_id])
            if ojects.count == 0
              {:error => 'ObjectID Error: Wrong object identifier'}
            else
              object = ojects.first
              object.update(params[:object])
            end
          else
            object = clazz.create(params[:object])
            object.save
          end
          {:object => object.to_hash, :success => true}
        }
      end

    end

    # Flow handling
    resource :flow do

      desc 'List all flows'
      params do
        requires :type, type: String, desc: 'Flow type'
        optional :state, type: String, desc: 'Flow state'
      end
      get :list do
        if params[:state].nil?
          set = Flow.all.to_a.select{|e| e.state != :closed}.map{|e| e.to_hash}
        else
          set = Flow.find(state: params[:state].to_sym).to_a.map{|e| e.to_hash}
        end
        paginate(set, params[:page], params[:limit])
      end

      desc 'Return a flow by item _id'
      params do
        requires :flow_id, type: String, desc: 'flow _identifier'
      end
      route_param :flow_id do
        get do
          authenticate!
          item = Item.find(_identifier: params[:flow_id]).first
          return {:error => 'Item not found'} if item.nil?
          flow = MFlow.find(item__id: item._id).first
          return {:error => 'Flow not found'} if flow.nil?
          flow.to_hash
        end
      end

    end

    # Event handling
    resource :event do

      desc 'Return the list of events of a flow'
      params do
        requires :flow_id, type: String, desc: 'Flow _id'
        optional :page, type: Integer, desc: 'Page num'
        optional :limit, type: Integer, desc: 'Page size'
      end
      get :list do
        authenticate!
        flow = Flow[params[:flow_id]]
        unless flow.nil?
          {:state => flow.state, :events => paginate(flow.events , params[:page], params[:limit])}
        else
          {:error => 'Flow not found'}
        end
      end

      desc 'Receive Business Event'
      params do
        requires :type, type: String, desc: 'Event type'
        optional :label, type: String, desc: 'Event label'
        optional :flow_id, type: String, desc: 'Flow _id'
      end
      post do
        authenticate!
        event = Event.create(type: params[:type], label: params[:label], flow_id: params[:flow_id])
        if params[:type] == 'start'
          flow = Flow.create
          events.add(Event.create(type: 'flow_created'))
          success = true
        else
          return {:error => 'Flow _id missing'} if params[:flow_id].nil?
          flow = MFlow[params['flow_id']]
          return {:error => 'Flow not found'} if flow.nil?
          Logger.new(STDERR).debug params[:journal].inspect
          success = flow.send(params['event'], params[:journal], event)
        end

        if success
          flow.events.add(event)
        else
          event.delete
        end
        flow.save

        {:success => success, :flow => flow.to_hash}
        end
=end


  end
end

