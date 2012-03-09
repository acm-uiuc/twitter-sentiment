require 'paint'
debug = :off # :off, :low, :med, :high
module PurdyPrint
    @@debug = :off
    def level_to_score level
        level = 0 if level == :off
        level = 1 if level == :low
        level = 2 if level == :med
        level = 3 if level == :high
        return level
    end
    def mood_from_score score
        :bhargav if score == 0
        :happy if score > 0
        :sad if score < 0
    end
    def pp mood=:info, msg="", debug_level=:off
        moods = {
            :info      => Paint["[info] ", [50,50,50]],
            :debug     => Paint["[dbug] ", [87,14,88]],
            :warn      => Paint["[warn] ", [255,197,44]],
            :error     => Paint["[erro] ", :red],
            :happy     => Paint["[ :) ] ", [151,192,12]],
            :sad       => Paint["[ :( ] ", [171,7,97]],
            :bhargav   => Paint["[ :| ] ", [200,200,200]],
            :seperator => Paint["======" , [50,50,50]]
        }
        mood=:info if not moods.member? mood
        puts moods[mood] + msg if level_to_score(debug_level) < level_to_score(@@debug)
    end
    def pp_exception e
        pp :error, "Exception caught (#{e})"
        e.backtrace.each { |exception_line| pp :error, "    #{exception_line}" }
    end
end