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

end
