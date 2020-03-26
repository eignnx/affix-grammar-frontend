-- Lesson 3: Data Variants

-- A rule can be parameterized by a "data variant." Let's define a data variant
-- to illustrate.

data Gender = nonbinary | feminine | masculine | neutral

-- An instance of `Gender` can be one of the four possibilities listed.

-- We'll try to generate sentences like:
--    "She fell over."
--    "They went to sleep."
--    "It flew away."
--    "He ate too much."

rule some_sentence
    = they.nonbinary "went to sleep."
    | they.feminine "fell over."
    | they.masculine "ate too much."
    | they.neutral "flew away."

-- To define the `they` rule, we have to declare that a `Gender` must be
-- supplied.
rule they.Gender =
    .nonbinary -> "They"
    .feminine -> "She"
    .masculine -> "He"
    .neutral -> "It"

-- We "pattern match" on the gender and specify what `they` should mean in each
-- case.

-- But we can do better! All of those sentences make sense (more or less)
-- regardless of grammatical gender. So lets use an "unknown data variant",
-- or "variable".

rule some_other_sentence
    = they.Gender "went to sleep."
    | they.Gender "fell over."
    | they.Gen "ate too much."
    | they.G "flew away."

-- To use a variable, just type the name of the data variant! Note that as long
-- as it's not ambiguous, you can shorten the name to a substring of the
-- original name.

-- We can now generate 16 sentences instead of just 4!

-- Finally, we'll write a rule that just prints out both of the previous rules
-- with some text to show from whence they came. Remember that `start` is the
-- root of every generated sentence.
rule start
    = "some_sentence:" some_sentence
    | "some_other_sentence:" some_other_sentence
