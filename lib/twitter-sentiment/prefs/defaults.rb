module TwitterSentiment
    module Prefs
        class Defaults
            def self.strip_regex 
                {
                    :url        => { # example: http://google.com
                        :regex  => /\(?\bhttp:\/\/[-A-Za-z0-9+&@#\/%?=~_()|!:,.;]*[-A-Za-z0-9+&@#\/%=~_()|]/,
                        :sub    => ''
                    },
                    :hashtag    => { # example: #amirite
                        :regex  => /#\w*/,
                        :sub    => ''
                    },
                    :reference  => { # example: @sigmusic_uiuc
                        :regex  => /@\w*/,
                        :sub    => ''
                    },
                    :lquote     => { # beginning of a quote mark that's not inside a word, left
                        :regex  => /(\W)['"]/,
                        :sub    => '\1'
                    },
                    :rquote     => { # beginning of a quote mark that's not inside a word, right
                        :regex  => /['"](\W)/,
                        :sub    => '\1'
                    },
                }
            end

            def self.twitter
                {
                    :user_id        => 480959867,
                    :user_name      => 'sigmusic_uiuc',
                    :search_phrase  => "#sxsw",
               }
           end
        end
    end
end