module ApplicationHelper

  def job_count_badge( status, count )
    badge = status_bootstrap_mappings(status)
    "<span class=\"badge badge-result badge-#{badge} badge-count-#{count}\">#{count}</span>".html_safe
  end

  def status_badge( status )
    "<span class=\"result result-#{status.to_s} \">#{status.to_s}</span>".html_safe
  end

  def filter_status_badge(status, type, batch_id=nil)
    link_path = ( type == :batches ) ? filter_batches_path(status) : batch_filter_path(batch_id, status)
    link_to "<span class=\"result result-#{status.to_s} \">#{status.to_s}</span>".html_safe, link_path
  end

  def status_bootstrap_mappings(status)
    {
        "pass"   => 'success',
        "fail"   => 'important',
        "error"  => 'inverse',
        "notrun" => 'default'
    }[status]
  end

  # Outputs a time from, realtive to the current time
  def pretty_time(time)
    if time
      time.strftime("%Y-%m-%d %H:%M:%S")
    else
      "~"
    end
  end

  # Outputs different time formats relative to the current time
  def simple_time(time)

    if !time
      "~"
    else

      now = Time.now

      format = "%Y-%m-%d %H:%M:%S"

      if time.year == now.year
        if time.yday == now.yday
          format = "%H:%M:%S"
        else
          format = "%d-%m %H:%M:%S"
        end
      end

      time.strftime(format)
    end
  end

  def pretty_truncate(string, length, emphasis, additional = nil)
    
    visible_text = string
    popup_text = ''
    
    if string.length > length
      popup_text = string
    end
    
    if additional
      popup_text = %{#{popup_text} #{additional}} 
    end
    
    if popup_text.length > 0
      html = %{<#{emphasis}><span id="str-#{string.object_id}" href="#" data-toggle="tooltip" title="#{popup_text}">#{string.truncate(length)}</span></#{emphasis}>}
      html += %{<script>$('#str-#{string.object_id}').tooltip({"animation": true })</script>}
    else
      html = "<#{emphasis}>#{string}</#{emphasis}>"
    end

    html.html_safe
  end
  
  def pretty_node( result )
    short_result = result.test_definition.node_type.split('::').last
    "<code>#{short_result}</code>".html_safe
  end
  
  def hive_url(args = {})
    if ENV['HIVE_URL']
      base = ENV['HIVE_URL']
      if args[:job]
        "#{base}/jobs/#{args[:job].to_s}"
      else
        base
      end
    else
      nil
    end
  end
  
  def hive_job_link( run )
    if hive_url && run.hive_job_id
      "<a href='#{hive_url(:job => run.hive_job_id)}'><img src='/images/hive-14.png'></img></a>".html_safe
    else
      ""
    end
  end

end
