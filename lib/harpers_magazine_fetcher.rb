require 'pdf/merger'
require 'mechanize'
require 'fileutils'

HARPERS_URL = 'http://www.harpers.org/'

class HarpersMagazineFetcher
  def initialize(username, password, issue_date, destination_dir)
    @username = username
    @password = password
    @issue_date = issue_date || Time.now.strftime('%Y/%m')
    @destination_dir = destination_dir || "/tmp/#{self.class.name}/#{Time.now.strftime("%Y-%m-%d-%H%M%S")}/#{@issue_date}"
    ensure_destination_dir_exists! @destination_dir
    @agent = ::Mechanize.new
  end

  def formatted_issue_date
    @issue_date.gsub('/', '-')
  end

  def go!
    login
    page = visit_issue(@issue_date)
    get_pdfs(page)
    combine_pdfs
  end

  def login
    @agent.get(::HARPERS_URL) do |page|
      page.form_with(:id => 'login') do |f|
        f['handle'] = @username
        f['password'] = @password
        f
      end.submit
    end
  end

  def visit_issue(date)
    date_str = date
    url = ::HARPERS_URL + 'archive/' + date_str
    @agent.get(url)
  end

  def combine_pdfs
    pdf = PDF::Merger.new
    Dir[File.join(@destination_dir, "*.pdf")].sort.each do |filepath|
      pdf.add_file(filepath)
    end

    path = "#{completed_path()}/harpers_magazine-#{formatted_issue_date()}.pdf"
    pdf.save_as(path)
    puts "magazine saved to #{path}"
  end

  def get_pdfs(page)
    links = page.search('a.pdf-link[title="View the PDF version of this article"]')
    links.each do |a|
      resource = a['href']
      file = @agent.get(resource)
      path = File.join(@destination_dir, file.filename)
      puts "saving #{file.filename} to #{path}"
      file.save(path)
    end
  end

  private

  def completed_path
    File.join(@destination_dir, 'combined')
  end

  def ensure_destination_dir_exists!(dir)
    ::FileUtils.mkdir_p(dir)
    ::FileUtils.mkdir_p(completed_path())
  end
end
