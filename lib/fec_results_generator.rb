require "fec_results_generator/version"
require "fec_results"
require "pp"

module FecResultsGenerator
  class JsonGenerator
    
    attr_reader :year
    
    def initialize(params={})
      params.each_pair do |k,v|
        instance_variable_set("@#{k}", v)
      end
    end
    
    def summary
      fec_results = FecResults::Summary.new(:year => year)
      create_dir(year, 'summary')
      ['party_labels', 'general_election_votes','general_election_votes_by_party','congressional_votes_by_election','chamber_votes_by_party'].each do |method|
        begin
          run(method, fec_results, 'summary')
        rescue NotImplementedError
          run_empty(method, 'summary')
        end
      end
    end
    
    def president
      fec_results = FecResults::President.new(:year => year)
      create_dir(year, 'president')
      ['popular_vote_summary', 'state_electoral_and_popular_vote_summary', 'primary_party_summary'].each do |method|
        begin
          run(method, fec_results, 'president')
        rescue NotImplementedError, NoMethodError
          run_empty(method, 'president')
        end
      end
      ['general_election_results', 'primary_election_results'].each do |method|
        begin
          run_results(method, fec_results, 'president')
        rescue NotImplementedError, NoMethodError
          run_empty(method, 'president')
        end
      end
    end
    
    def congress
      fec_results = FecResults::Congress.new(:year => year)
      create_dir(year, 'congress')
      run_results('results', fec_results, 'congress')
    end
    
    def run(method, fec_results, type)
      data = generate_json(fec_results.send(method))
      write_to_file("api/#{year}/#{type}","#{method}.json", data.map{|d| d['table'].to_json})
    end
    
    def run_results(method, fec_results, type)
      data = generate_json(fec_results.send(method))
      write_to_file("api/#{year}/#{type}","#{method}.json", data.map{|d| d.to_json})
    end
        
    def generate_json(results)
      data = results.map{|r| JSON.parse(r.to_json)}
    end
    
    def run_empty(method, type)
      write_to_file("api/#{year}/#{type}","#{method}.json", [])
    end
    
    def write_to_file(dir, file, json)
      File.open(File.join(dir, file), 'w') do |f|
        PP.pp(json,f)
      end
    end
    
    def create_dir(year, type)
      FileUtils.mkdir_p "api/#{year}/#{type}/"
    end
    
  end
  
end
