/* framework code */
function playAYFrameStream(commandStream) {
	openDynamicAudio({'rate': 44100, 'channels': 1}, function(target) {
		var AY_FREQUENCY = 1773400;
		var COMMAND_FREQUENCY = 50;

		ay = AYChip({
			'frequency': AY_FREQUENCY, 'sampleRate': target.rate
		});

		target.fillBuffer = function(buffers, offset, length) {
			// console.log('fillBuffer at ' + (new Date).getTime())
			ay.useBuffer(buffers, offset, length);
			while (ay.flush()) {
				var hasData = commandStream.applyCommandsForFrame(ay);
				if (!hasData) {
					target.done();
					break;
				}
				ay.runFor(AY_FREQUENCY / COMMAND_FREQUENCY);
			}
			return ay.generatedSampleCount;
		};
	});
}

function AYChip(opts) {
	var VOLUME_LEVELS = [
		0.000000, 0.004583, 0.006821, 0.009684,
		0.014114, 0.020614, 0.028239, 0.045633,
		0.056376, 0.088220, 0.117568, 0.149977,
		0.190123, 0.229088, 0.282717, 0.333324
	];

	var frequency = opts.frequency;
	var sampleRate = opts.sampleRate;

	var cyclesPerSample = frequency / sampleRate;

	var self = {};

	var buffers;
	var bufferOffset;
	var bufferEnd;
	var cyclesUntilNextCommand = 0;

	var toneGeneratorAPhase = 0;
	var toneGeneratorAPeriod = 8;
	var toneGeneratorACounter = 0;

	var toneGeneratorBPhase = 0;
	var toneGeneratorBPeriod = 8;
	var toneGeneratorBCounter = 0;

	var toneGeneratorCPhase = 0;
	var toneGeneratorCPeriod = 8;
	var toneGeneratorCCounter = 0;

	var noiseGeneratorPhase = 0;
	var noiseGeneratorPeriod = 16;
	var noiseGeneratorCounter = 0;
	var noiseGeneratorSeed = 1;

	var toneChanAMask = 0x00;
	var toneChanBMask = 0x00;
	var toneChanCMask = 0x00;
	var noiseChanAMask = 0x00;
	var noiseChanBMask = 0x00;
	var noiseChanCMask = 0x00;

	var envelopePeriod = 256;
	var envelopeCounter = 0;
	var envelopeRampCounter = 16;
	var envelopeOnFirstRamp = true;
	var envelopeAlternateMask = 0x00;
	var envelopeAlternatePhase = 0x00;
	var envelopeHoldMask = 0x00;
	var envelopeAttackMask = 0x00;
	var envelopeContinueMask = 0x00;
	var envelopeValue = 0x00;

	var registers = new Uint8Array(14);

	self.generatedSampleCount = 0;
	self.useBuffer = function(_buffers, _offset, _length) {
		buffers = _buffers;
		bufferOffset = _offset;
		bufferEnd = _offset + _length;
		self.generatedSampleCount = 0;
	};
	self.runFor = function(cycleCount) {
		cyclesUntilNextCommand += cycleCount;
	};
	self.setRegister = function(reg, val) {
		registers[reg] = val;
		switch(reg) {
			case 0:
			case 1:
				toneGeneratorAPeriod = (((registers[1] & 0x0f) << 8) | registers[0]) * 8;
				if (toneGeneratorAPeriod === 0) toneGeneratorAPeriod = 8;
				break;
			case 2:
			case 3:
				toneGeneratorBPeriod = (((registers[3] & 0x0f) << 8) | registers[2]) * 8;
				if (toneGeneratorBPeriod === 0) toneGeneratorBPeriod = 8;
				break;
			case 4:
			case 5:
				toneGeneratorCPeriod = (((registers[5] & 0x0f) << 8) | registers[4]) * 8;
				if (toneGeneratorCPeriod === 0) toneGeneratorCPeriod = 8;
				break;
			case 6:
				noiseGeneratorPeriod = (val & 0x1f) * 16;
				if (noiseGeneratorPeriod === 0) noiseGeneratorPeriod = 16;
				break;
			case 7:
				toneChanAMask = (val & 0x01) ? 0xff : 0x00;
				toneChanBMask = (val & 0x02) ? 0xff : 0x00;
				toneChanCMask = (val & 0x04) ? 0xff : 0x00;
				noiseChanAMask = (val & 0x08) ? 0xff : 0x00;
				noiseChanBMask = (val & 0x10) ? 0xff : 0x00;
				noiseChanCMask = (val & 0x20) ? 0xff : 0x00;
				break;
			case 11:
			case 12:
				envelopePeriod = ((registers[12] << 8) | registers[11]) * 16;
				if (envelopePeriod === 0) envelopePeriod = 16;
				break;
			case 13:
				envelopeCounter = 0;
				envelopeRampCounter = 16;
				envelopeOnFirstRamp = true;
				envelopeAlternatePhase = 0x00;
				envelopeHoldMask = (val & 0x01) ? 0x0f : 0x00;
				envelopeAlternateMask = (val & 0x02) ? 0x0f : 0x00;
				envelopeAttackMask = (val & 0x04) ? 0x0f : 0x00;
				envelopeContinueMask = (val & 0x08) ? 0x0f : 0x00;
				break;
		}
	};
	self.flush = function() {
		while (true) {
			if (cyclesUntilNextCommand <= 0) return true;
			if (bufferOffset == bufferEnd) return false;

			toneGeneratorACounter -= cyclesPerSample;
			while (toneGeneratorACounter < 0) {
				toneGeneratorACounter += toneGeneratorAPeriod;
				toneGeneratorAPhase ^= 0xff;
			}

			toneGeneratorBCounter -= cyclesPerSample;
			while (toneGeneratorBCounter < 0) {
				toneGeneratorBCounter += toneGeneratorBPeriod;
				toneGeneratorBPhase ^= 0xff;
			}

			toneGeneratorCCounter -= cyclesPerSample;
			while (toneGeneratorCCounter < 0) {
				toneGeneratorCCounter += toneGeneratorCPeriod;
				toneGeneratorCPhase ^= 0xff;
			}

			noiseGeneratorCounter -= cyclesPerSample;
			while (noiseGeneratorCounter < 0) {
				noiseGeneratorCounter += noiseGeneratorPeriod;

				/* TODO: replace this with the accurate RNG as posted to WOS in late 2012 */
				if ((noiseGeneratorSeed & 1) ^ ((noiseGeneratorSeed & 2) ? 1 : 0))
					noiseGeneratorPhase ^= 0xff;

				/* rng is 17-bit shift reg, bit 0 is output.
				* input is bit 0 xor bit 2.
				*/
				noiseGeneratorSeed |= (
					(noiseGeneratorSeed & 1) ^ ((noiseGeneratorSeed & 4 ) ? 1 : 0)
				) ? 0x20000 : 0;
				noiseGeneratorSeed >>= 1;
			}

			envelopeCounter -= cyclesPerSample;
			while (envelopeCounter < 0) {
				envelopeCounter += envelopePeriod;

				envelopeRampCounter--;
				if (envelopeRampCounter < 0) {
					envelopeRampCounter = 15;
					envelopeOnFirstRamp = false;
					envelopeAlternatePhase ^= 0x0f;
				}

				envelopeValue = (
					/* start with the descending ramp counter */
					envelopeRampCounter
					/* XOR with the 'alternating' bit if on an even-numbered ramp */
					^ (envelopeAlternatePhase && envelopeAlternateMask)
				);
				/* OR with the 'hold' bit if past the first ramp */
				if (!envelopeOnFirstRamp) envelopeValue |= envelopeHoldMask;
				/* XOR with the 'attack' bit */
				envelopeValue ^= envelopeAttackMask;
				/* AND with the 'continue' bit if past the first ramp */
				if (!envelopeOnFirstRamp) envelopeValue &= envelopeContinueMask;
			}

			var levelA = VOLUME_LEVELS[
				((registers[8] & 0x10) ? envelopeValue : (registers[8] & 0x0f))
				& (toneGeneratorAPhase | toneChanAMask)
				& (noiseGeneratorPhase | noiseChanAMask)
			];
			var levelB = VOLUME_LEVELS[
				((registers[9] & 0x10) ? envelopeValue : (registers[9] & 0x0f))
				& (toneGeneratorBPhase | toneChanBMask)
				& (noiseGeneratorPhase | noiseChanBMask)
			];
			var levelC = VOLUME_LEVELS[
				((registers[10] & 0x10) ? envelopeValue : (registers[10] & 0x0f))
				& (toneGeneratorCPhase | toneChanCMask)
				& (noiseGeneratorPhase | noiseChanCMask)
			];

			buffers[0][bufferOffset] = (levelA + levelB + levelC);
			bufferOffset++;
			self.generatedSampleCount++;

			cyclesUntilNextCommand -= cyclesPerSample;
		}
	};

	return self;
}