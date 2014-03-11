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

  def pretty_truncate(string, length, emphasis)
    if string.length > length
      html = %{<#{emphasis}><span id="str-#{string.object_id}" href="#" data-toggle="tooltip" title="#{string}">#{string.truncate(length)}</span></#{emphasis}>}
      html += %{<script>$('#str-#{string.object_id}').tooltip({"animation": true })</script>}
    else
      html = "<#{emphasis}>#{string}</#{emphasis}>"
    end

    html.html_safe
  end

end
