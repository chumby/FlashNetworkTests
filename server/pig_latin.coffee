#
# translates text to pig latin https://en.wikipedia.org/wiki/Pig_Latin
#
class PigLatin
	@gcsVOWELS = "AEIOUaeiou"
	@gcsVOWELSY = "AEIOUaeiouYy"
	@gcsWAY = "way"
	@gcsAY = "ay"

	@translate:(sText)->
		sPigLatin = ""
		sLine = ""
		sWord = ""
		bWord = true
		for iChar of sText
			sChar = sText.charAt iChar
			if (sChar >= 'A' && sChar<='Z') || (sChar>='a' && sChar<='z') || (sChar=="'" && bWord && sWord!="")
				unless bWord
					sLine += sWord
					sWord = ""
					bWord = true
				sWord += sChar
			else
				if bWord && sWord!=""
					sWord = @translateWord sWord
					sLine += sWord
					sWord = ""
				sWord += sChar
				bWord = false
				if sChar=="\r" || sChar=="\n"
					sPigLatin += sLine+sWord
					sLine = ""
					sWord = ""
		sPigLatin+sLine+sWord
	
	@translateWord:(psWord)->
		sWord = psWord
		sFirst = sWord.charAt 0
		bCapitalize = sFirst==sFirst.toUpperCase()
		sSuffix = ""
		if 0<=@gcsVOWELS.indexOf sFirst
			sSuffix = @gcsWAY
			sLast = sWord.charAt sWord.length-1
			if sLast==sLast.toUpperCase() && sWord.length>1
				sSuffix = @gcsWAY.toUpperCase()
		else
			unless sWord==sWord.toUpperCase()
				sFirst = sFirst.toLowerCase()
			iChars = sWord.length
			while iChars--
				sSuffix += sFirst
				sLast = sFirst
				bCapsFlag = sFirst==sFirst.toUpperCase()
				sWord = sWord.substring 1,sWord.length
				sFirst = sWord.charAt 0
				if 0<=@gcsVOWELSY.indexOf sFirst
					unless (sLast=='q' || sLast=='Q') && (sFirst=='u' || sFirst=='U')
						break
			sSuffix += if bCapsFlag then @gcsAY.toUpperCase() else @gcsAY
		sWord += sSuffix
		if bCapitalize
			sFirst = sWord.charAt 0
			sWord = sFirst.toUpperCase() + sWord.substring 1,sWord.length
		sWord

console.log PigLatin.translate '<translate text="some text"/>'

module.exports = PigLatin