// Package home is Leon's personal home realm, deployed under gno.land/r/leon/home
// It is meant to act as Leon's profile page on gno.land
package home

import (
	"std"
	"strconv"

	"gno.land/p/demo/ufmt"
	"gno.land/r/demo/art/gnoface"
	"gno.land/r/demo/art/millipede"
	"gno.land/r/leon/config"
)

var (
	pfp        string // link to my profile pic
	pfpCaption string
	abtMe      [2]string
)

func init() {
	pfp = "https://i.imgflip.com/91vskx.jpg"
	pfpCaption = "[My favourite painting & pfp](https://en.wikipedia.org/wiki/Wanderer_above_the_Sea_of_Fog)"
	abtMe = [2]string{
		`### About me
Hi, I'm Leon, a DevRel Engineer at gno.land. I am a tech enthusiast, 
life-long learner, and sharer of knowledge.`,
		`### Contributions
My contributions to gno.land can mainly be found 
[here](https://github.com/gnolang/gno/issues?q=sort:updated-desc+author:leohhhn).

TODO import r/gh`,
	}
}

// Updating

func UpdateAbtMe(col1, col2 string) {
	config.AssertAuthorized()
	abtMe[0] = col1
	abtMe[1] = col2
}

// Todo: make setters for all pkg-level variables

// Rendering

func Render(_ string) string {
	output := "# Leon's Homepage\n\n"

	output += renderAboutMe()
	output += "\n\n"
	output += renderArt()

	return output
}

func renderAboutMe() string {
	out := "<div class='columns-3'>"

	out += "<div>\n\n"
	out += ufmt.Sprintf("![](%s)\n\n%s\n\n", pfp, pfpCaption)
	out += "</div>\n\n"

	out += "<div>\n\n"
	out += abtMe[0] + "\n\n"
	out += "</div>\n\n"

	out += "<div>\n\n"
	out += abtMe[1] + "\n\n"
	out += "</div>\n\n"

	out += "</div>"
	return out
}

func renderArt() string {
	out := `<div class=jumbotron>` + "\n\n"
	out += "## Gno Art\n\n"
	out += "<div class='columns-3'>"

	out += renderGnoFace()
	out += renderMillipede()
	out += renderGnoFace()

	out += "</div><!-- /columns-3 -->"
	out += "</div><!-- /jumbotron -->"

	return out
}

func renderGnoFace() string {
	out := "<div>\n\n"
	out += gnoface.Render(strconv.Itoa(int(std.GetHeight())))
	out += "</div>\n\n"

	return out
}

func renderMillipede() string {
	out := "<div>\n\n"
	out += "Millipede\n\n"
	out += "```\n" + millipede.Draw(int(std.GetHeight()%10+1)) + "```\n"
	out += "</div>\n\n"

	return out
}
