-- Lesson 2: Joining Words Together

rule start = "These" "are" "a" "few" things + "!"

rule things = "words" | "sentence elements" | "lexemes"

-- When two sentence elements (like "quoted text" or rule_names) are placed
-- next to each other, they are implicitly joined together and separated
-- by a space (" "). So writing:
--    "Stop" "thief!"
-- is the same as writing:
--    "Stop thief!"

-- This is usually what you want, but sometimes you'll want two sentence
-- elements joined together without a space. To do this, put a plus sign (+)
-- between the two. Writing:
--    "Stop thief" + "!"
-- is the same as writing:
--    "Stop thief!"

-- Often you'll want to use the plus sign to append punctuation onto the end of
-- a sentence.