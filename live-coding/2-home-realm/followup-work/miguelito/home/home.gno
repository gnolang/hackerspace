package home

import (
	"std"
	"gno.land/p/demo/ui"

	)

func Render(string) string {

	dom := ui.DOM{Prefix: "r/gnoland/home:"}
	dom.Title = "Welcome to the MiguelitOhm ॐ"
	dom.Classes = []string{"gno-tmpl-section"}

	dom.Body.Append(introSection()...)
	dom.Body.Append(
		ui.Columns{2, []ui.Element{
			socialLinks(),
			philosophyQuotes(),
		}},
	)

	return dom.String()
}

func introSection() ui.Element {
	return ui.Element{
		ui.Paragraph("Hello, my name is Miguelitø, passionned about Music, (E)Sports and Technology. Most likely trying to build on this innovative project."),
		ui.Paragraph("Building 76TemD : Arts & Entertainment"),
		ui.Paragraph("I'll try to make updates of this home as far as I gno forward"),
		ui.Italic("Last update : 09/29/24"),
	}
}

func philosophyQuotes() ui.Element {
	quotes := []string{
		"Music is the universal language that speaks to the soul beyond words.",
		"Blockchain empowers learning by making trust transparent and knowledge secure.",
		"Education is the rhythm of progress, where each note builds a future.",
		"Like a well-composed song, blockchain harmonizes truth with accountability.",
		"In a decentralized world, knowledge becomes a shared composition, available to all.",
		"Music teaches us connection, blockchain teaches us trust, and education teaches us possibility.",
		"Blockchain is to trust what music is to emotion — a universal force that transcends borders.",
		"When education is open-source, it becomes a collective symphony of wisdom.",
		"Blockchain builds trust like a melody builds momentum, one block, one note at a time.",
		"Music binds hearts, blockchain binds systems, and education binds minds.",
	}

	height := std.GetHeight()
	idx := int(height) % len(quotes)
	qotb := quotes[idx]

	return ui.Element{
		ui.H3("Philosophycal Quote :"),
		ui.H6("Education, Innovation, Inspiration"),
		ui.Quote(qotb),
	}
}

func socialLinks() ui.Element {
	return ui.Element{
		ui.H3("Some Socials"),
		ui.BulletList{
			ui.H5("[GitHub](https://github.com/miguelito766)"),
			ui.H5("Discord : #miguelito766"),
			ui.H5("[Twitter](https://twitter.com/miguelito766)"),
			ui.H5("[Miguelitø - Soundcloud](https://soundcloud.com/miguelito766)"),
			ui.H5("[76TemD - Soundcloud](https://soundcloud.com/76temd)"),
		},
	}
}