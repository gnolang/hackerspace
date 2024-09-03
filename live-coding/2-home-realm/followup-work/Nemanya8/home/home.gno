package home

import (
	"gno.land/r/nemanya/config"
)

var (
	aboutMe	string
	projects [4]string
)

func init()  {
	aboutMe =`### About me
I'm Nemanya from Serbia, an IT student and aspiring Web3 developer. 
I discovered gno.land at the Petnica Web3 Camp and I'm eager to make significant contributions to this project.`

	projects = [4]string{
		"[Liberty Bridge](https://github.com/Milosevic02/LibertyBridge)",
		"[Coming Soon!](#)",
		"[Coming Soon!](#)",
		"[Coming Soon!](#)",
	}
}

func UpdateAboutMe(newAboutMe string)  {
	config.AssertAuthorized()
	aboutMe = newAboutMe
}

func UpdateProjects(project1, project2, project3, project4 string)  {
	config.AssertAuthorized()
	projects[0] = project1
	projects[1] = project2
	projects[2] = project3
	projects[3] = project4
}

func Render(path string) string {
	out := "<div class='columns-2'style='padding: 20px;'>\n\n"

	out += renderAboutMe()
	out += renderProjects()
	out += "\n\n"

	out += "</div>\n\n"
	return out
}

func renderAboutMe() string {
	out := "<div class='rows-3'>"
	out += "<h1>Nemanya.</h1>"
	out += "<div>\n\n"
	out += aboutMe + "\n\n"
	out += "</div>\n\n"
	out += "<div>\n\n"
	out += "Placeholder for links to socials"
	out += "</div>\n\n"
	out += "</div><!-- /rows-3 -->\n\n"
	return out
}

func renderProjects() string {
	out := "<div class='rows-5'>"
	out += "<h2>Projects</h2>"

	out += "<div>\n\n"
	out += projects[0] + "\n\n"
	out += "</div>\n\n"

	out += "<div>\n\n"
	out += projects[1] + "\n\n"
	out += "</div>\n\n"

	out += "<div>\n\n"
	out += projects[2] + "\n\n"
	out += "</div>\n\n"

	out += "<div>\n\n"
	out += projects[3] + "\n\n"
	out += "</div>\n\n"

	out += "</div><!-- /rows-5 -->\n\n"
	return out
}
