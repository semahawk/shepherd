module Shepherd
  module Version
    MAJOR = 0
    MINOR = 3
    PATCH = 1
    BUILD = nil

    STRING = [MAJOR, MINOR, PATCH, BUILD].compact.join "."
  end
end
