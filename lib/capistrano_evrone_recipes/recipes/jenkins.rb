namespace :jenkins do
  task :check_last_build do
    require 'nokogiri'
    require 'open-uri'

    url = 'http://ci.kupikupon.ru/'
    begin
      doc = Nokogiri::HTML(open(url))

      status = "Unknown"
      doc.css("tr#job_#{kk_repo_name} > td:first > img").each do |img|
        status = img.attributes["alt"].value
      end

      if status != 'Success'
        unless agree = Capistrano::CLI.ui.agree("Last build is #{status}, are you sure? (Yes, [No]) ")
          exit
        end
      end
    rescue
      p "Can't check jenkins status"
    end
  end
end
