# For obscure reasons, if Rails gets an XMLHttpRequest with an Accept header like
# "application/json, text/javascript, */*; q=0.01" and does not get an
# X-Requested-With header, it will report that HTML is the desired format in calls
# to `respond_to`. This monkey patch should fix the problem. I think the worst
# possible side effect is that certain old browsers might display some content wrong.
if is_in_sandstorm?
  module ActionDispatch
    module Http
      module MimeNegotiation
        def valid_accept_header
          true
        end
      end
    end
  end
end
