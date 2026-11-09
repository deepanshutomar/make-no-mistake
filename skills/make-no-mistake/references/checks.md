# Type-specific checks

Load only the section that matches the output. Each check produces evidence for the contract, not a separate wish list.

## Code

- **It runs.** Build or launch it and capture the output. For a library, import it and call the changed function.
- **Tests.** Run the existing suite for the touched area. If a contract criterion has no test, write a throwaway one that proves it, run it, then delete it unless the user wants tests.
- **Edge cases from the request.** Only the ones the request implies: empty input, the user's example input, the error path they described.
- **Diff scope.** `git diff --stat`, or compare files. Flag changes to files the task didn't need, deleted code nobody asked to remove, leftover debug prints, TODOs and placeholder values.
- **UI.** Open it in a browser, screenshot the changed screen and click the changed flow once. Check the console for errors.
- **Large repos.** Verify the changed modules and their direct callers only. Anything beyond that goes through the scope gate.

## Scripts (video, reel, podcast, ad copy)

- **Length.** Count words. Spoken pace is about 150 words per minute (130 for slow, 170 for fast). Compare against the requested duration.
- **Hook.** The first line earns attention on its own, with no warm-up sentence before it.
- **Brief coverage.** Every point, product mention, CTA or sign-off the brief asked for is present.
- **Voice and preferences.** Language, register, banned words, how the creator refers to people, naming rules, any saved style preferences.
- **Read-aloud pass.** Read it as the speaker would. Flag tongue-twisters, sentences over ~25 words, and lines that only work on paper.
- **Facts.** Every claim, number or name either traces to a source or the user's input, or gets flagged.

## Video renders

Probe the file. Don't trust the export settings you think you used.

```bash
ffprobe -v error -show_entries stream=codec_name,width,height,r_frame_rate,bit_rate,pix_fmt -show_entries format=duration,bit_rate -of default=nw=1 OUTPUT
ffprobe ... SOURCE    # compare side by side
```

- **Quality parity.** Resolution, frame rate and pixel format match the source unless the user asked otherwise. Bitrate is not visibly lower than the source. Re-encodes keep quality (CRF ≤ 18 for H.264, or a source-matching bitrate).
- **Duration.** Matches the expected cut. No missing tail or frozen last frame.
- **Audio.** An audio stream exists, and sync holds at start, middle and end. Loudness is near the target (about −14 LUFS for social): `ffmpeg -i OUTPUT -af ebur128 -f null -`.
- **Black or frozen frames.** `ffmpeg -i OUTPUT -vf blackdetect=d=0.3 -an -f null -` and `freezedetect`.
- **Visual sampling.** Extract frames at 0%, 10%, 50%, 90% and at every edit point or caption change you touched, then look at them: `ffmpeg -ss T -i OUTPUT -frames:v 1 frame_T.png`. Check that captions are spelled right, sit inside the safe area and are timed to speech.
- **Long media.** Don't watch everything. Sample as above, plus the specific timestamps the request was about.

## Documents (docs, PDFs, slides, sheets)

- **Open the real file.** Render to PDF or images and look at the pages. Don't judge from the source markup.
- **Structure.** Every requested section exists, in the requested order. Page or slide count is within any limit.
- **Formatting.** Nothing overflows, overlaps, gets cut off or ends up as an empty page. Fonts and styles are consistent.
- **Consistency.** Names, numbers, dates and terms are the same everywhere they appear.
- **Facts and sources.** Claims trace to a source or to the user's input. Citations point where they say they do.
- **Spreadsheets.** Formulas evaluate with no `#REF!` or `#DIV/0!`. Spot-check two totals by recomputing them independently.
- **Preferences.** Pronoun rules ("I" vs "we"), no added details the user didn't ask for, required branding.

## Designs and web pages

- Screenshot at mobile (~390 px) and desktop (~1440 px) widths.
- Text is readable, contrast is fine, and nothing overflows or overlaps.
- Every link and button in the brief goes somewhere real.
- Requested copy appears word for word wherever it was supplied.

## Data and analysis

- Recompute the headline numbers yourself with a different method or tool than the worker used.
- Check row counts before and after each filter or join. Unexpected drops are failures.
- Charts: axes labeled, units right, and the chart shows what the claim says it shows.

## Anything else

Role-play the end user: take the output and try to do the thing the Goal line says they'll do with it. Every point where you get stuck, have to guess or need to fix something by hand is a `FAIL`.
