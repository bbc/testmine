class API::V1::ResultsController < API::V1Controller

  def ingest_ir

    begin
      run = IrIngestor.parse_ir( params['data'] )
    rescue Exception => e
      error = e.to_s + " --> " + e.backtrace.to_s
      render text: error
    end

    if run
      render text: run.id
    end

  end

end
