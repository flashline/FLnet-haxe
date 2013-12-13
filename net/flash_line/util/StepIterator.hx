/**
 * Copyright (c) jm Delettre.
 * 
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 *   - Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   - Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */
package net.flash_line.util ;
/**
	Integer iterator with step
**/
class StepIterator {

	var min : Int;
	var max : Int;
	 var step:Int;

	/**
		Iterate from [min] (inclusive) to [max] (exclusive) by [step].
	**/
	public function new( min : Int, max : Int, ?step:Int ):Void {
		this.min = min;
		this.max = max;
		if (step == null) {
			if (min < max) step = 1;
			else step = -1;
		}
		if (min <= max && step < 0 || min > max && step >= 0) step *= -1; 
		this.step = step;
	}

	/**
		Returns true if the iterator has other items, false otherwise.
	**/
	public function hasNext():Bool {
		var ret:Bool;
		if (step>0) ret=(min  < max);
		else  ret=(min  > max);
		return ret;
	}

	/**
		Moves to the next item of the iterator.
	**/
	public function next() :Int {
		var ret = min;
		min += step;
		return ret;		
	}

}
