# Swift Student Challenge 2020 Submission (Winner)

This was my submission for the 2020 Swift Student Challenge. The submission was accepted and as a winner, my app [Charcoal](https://larztech.com/projects/charcoal/about/) got featured on the App Store. To make the project more accessible, I decided to open-source the playground as an iOS app.

If you are interested in any of the technologies I used, you can read [my blog](https://larztech.com).

***A quick note about the CoreML part:** I was not able to figure out how to make the model trainable in time so I worked around it. You can find my solution in the technical documentation and in the page 2 source files.*

Also: Please don't try to submit this again next year.

## Technical Documentation
My playground is a collection of utilities that can help people who are hard of hearing. Included in the playground are three separate utilities with different use-cases.

The first utility is a frequency-based hearing test. The older people get, the less high frequencies they can hear. This test uses this information to determine how ”old“ your ears are. This age should be similar to your own age. For generating the sound in real-time, I used AVFoundation’s `AVAudioEngine`. To allow the sliders to be changed and their value to be represented in the played audio, I used `AVAudioSourceNode`, which was introduced in iOS 13. Most frequency hearing tests are videos, but this test is fully interactive, which allows you to take more time to fine-tune the values to get a better result. Once you have tested your hearing, you can jump to the second utility.

The second utility uses various audio effects to optimize recorded audio to make voices more understandable. For people who are hard of hearing, understanding voices can sometimes be difficult when there are lots of noises in the background. This utility tries to optimize audio by reducing frequencies which often contain background sounds. The audio will also be played back more loudly. To achieve these effects, I (again) used AVFoundation’s `AVAudioEngine`. This time I also used various `AVAudioUnit`s such as `AVAudioUnitEQ`. The effects get applied in real-time. To enable exporting, the manipulated audio also gets written to disk. When everything is put together, voices are way more understandable in the played audio.

The third utility can help someone who is hard of hearing differentiate between multiple sounds. In many situations, you need to differentiate between two or more sounds, which can be a problem if you can’t hear those sounds. On this page, you can teach the playground to differentiate between multiple sounds. Once you added two or more sounds, you can press ”Recognize Sound“ to classify a recording. To let the user add their own sounds, I trained a custom Core ML model in Create ML. This model was then added to the playground. When a user first records a sound, the model looks for patterns it already knows and then saves its classification. When the user lets the playground recognize another sound, the classification of the new sound gets compared to all existing classifications. If two classifications match, the result gets presented to the user. When adding a sound, you don’t train the model directly, which is more efficient and faster.

## License
This project is released under the MIT license. See the LICENSE file for more info.
