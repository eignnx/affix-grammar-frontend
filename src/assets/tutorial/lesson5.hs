-- Lesson 5: Agreement

-- Check out this example:

data Character
    = sam ("Sam")
    | val ("Val")
    | penny ("Penny")

rule bad_story = "Yesterday," @Character "met up with their friend," @Character + "."

-- This story probably doesn't do what you want. Here's what's generated:

--    "Yesterday Sam met up with their friend Sam."
--    "Yesterday Val met up with their friend Val."
--    "Yesterday Penny met up with their friend Penny."

-- We want to be able to say that two variables are independent from one
-- another. To do this, attach a number on the end of the variable name:

rule good_story = "Yesterday," @Character1 "met up with their friend," @Character2 + "."

-- Now `Character1` doesn't have to be the same as `Character2`. These are some
-- of the generated sentences:

--    "Yesterday Sam met up with their friend Val."
--    "Yesterday Penny met up with their friend Sam."
--    "Yesterday Val met up with their friend Sam."

-- Note that this sentence is still possible though:

--    "Yesterday Val met up with their friend Val."

-- There's currently no way to restrict two variables so that both DEFINITELY
-- have different values. 😔

rule start = "bad:" bad_story | "good:" good_story