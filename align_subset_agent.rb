#!/usr/local/bin/ruby

require 'mongo_agent'

def indexed?(reference_file)
  if File.exists? reference_file
    if File.exists? "#{reference_file}.bwt"
      if File.exists? "#{reference_file}.fai"
        return true
      end
    end
  end
  false
end

agent = MongoAgent::Agent.new({name: 'align_subset_agent', queue: ENV['QUEUE']})
agent.work! { |task|
  #task = { build, reference, raw_file, subset, parent_id, agent_name: align_subset_agent, ready:true }
  response = false

  begin
    reference_file = ['/home/bwa_user', 'bwa_indexed', task[:build], task[:reference]].join('/')
    unless indexed?(reference_file)
     raise "#{ task[:reference] } does not exist for #{ task[:build] }, or is not indexed properly!"
    end

    subset_file = ['/home/bwa_user', 'data', task[:subset]].join('/')
    unless File.exists?(subset_file)
      raise "#{ task[:subset] } does not exist!"
    end

    command = [
      "/usr/local/bin/bwa_aligner.pl",
      '-s', task[:subset],
      '-b', task[:build],
      '-R', task[:reference]
    ]
    $stderr.puts "RUNNING #{ command.join(' ') }"
    unless system *command
      raise "Could not run #{ command }"
    end

    subset_bam = "#{ task[:subset] }.bam"
    subset_bam_file = "#{ subset_file }.bam"
    unless File.exists?(subset_bam_file)
      raise "#{ subset_bam_file } does not exist!?"
    end
    files_produced = [{
      name: subset_bam,
      sha1: `sha1sum #{ subset_bam_file }`.split(' ')[0]
    }]
    response = [true, { files: files_produced }]
  rescue Exception => error
    response = [false, {error_message: error.message}]
  end
  response
}
