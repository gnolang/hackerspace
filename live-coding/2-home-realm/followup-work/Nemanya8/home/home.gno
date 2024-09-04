package home

import (
	"gno.land/r/nemanya/config"
)

var (
	aboutMe	string
	projects [4]string
	socials [3]string
)

func init()  {
	aboutMe ="I'm Nemanja Matic from Serbia, an IT student and aspiring Web3 developer. I discovered gno.land at the Petnica Web3 Camp and I'm eager to make significant contributions to this project."

	projects = [4]string{
		"[Liberty Bridge](https://github.com/Milosevic02/LibertyBridge)",
		"[Coming Soon!](#)",
		"[Coming Soon!](#)",
		"[Coming Soon!](#)",
	}

	socials = [3]string{
		"[GitHub](https://github.com/Nemanya8)",
		"[LinkedIn](https://www.linkedin.com/in/nemanjamatic)",
		"[Email](matic.nemanya@gmail.com)",
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
    out := "<div style='display: flex;'>\n\n"

    out += "<div style='flex: 8; margin-right: 20px; position: relative; padding: 2rem;'>"
    out += renderAboutMe()
    out += "<div style='position: absolute; top: 0; left: 0; right: 0; bottom: 0; border: 2px solid transparent; border-image: linear-gradient(166deg, rgba(211,0,0,1) 0%, rgba(0,0,0,0) 20%); border-image-slice: 1;'></div>"
    out += "</div>"
    
    out += "<div style='flex: 2; position: relative; padding: 2rem;'>"
	out += renderProjects()
	out += "<div style='position: absolute; top: 0; left: 0; right: 0; bottom: 0; border: 2px solid transparent; border-image: linear-gradient(324deg, rgba(211,0,0,1) 0%, rgba(0,0,0,0) 20%); border-image-slice: 1;'></div>"
    out += "</div>\n\n"
    out += "</div>\n\n"
    return out
}



func renderAboutMe() string {
    out := "<div class='rows-3'>"
    out += "<h1 style='font-family: Inter, sans-serif; font-weight: 200; color: #FEFEFE; text-align: left; font-size: 7rem;'>Nemanya.</h1>"
    out += "<div style='border-left: 1px solid #D30000; padding-left: 1rem;'>"
    out += "<p style='font-family: Inter, sans-serif; color: #FEFEFE; font-size: 2rem;'>"
    out += aboutMe
    out += "</p>\n\n"
    out += "</div>\n\n"
    out += "<div class='socials-container' style='display: flex; justify-content: center; align-items: center; gap: 20px;'>\n\n"
    out += "<div style='display: flex; justify-content: center; align-items: center;'>\n\n"
    out += socials[0]
    out += "</div>\n"
    out += "<div style='display: flex; justify-content: center; align-items: center;'>\n\n"
    out += socials[1]
    out += "</div>\n"
    out += "<div style='display: flex; justify-content: center; align-items: center;'>\n\n"
    out += socials[2]
    out += "</div>\n"
    out += "</div>\n\n"
    out += "</div><!-- /rows-3 -->\n\n"
    return out
}


func renderProjects() string {
	out := "<div class='rows-5'>"
	out += "<h2 style='font-family: Inter, sans-serif; font-weight: 200; color: #FEFEFE; text-align: left; font-size: 4rem;'>Projects</h2>"

	out += "<div style='border-left: 1px solid #D30000; padding-left: 1rem;'>\n\n"
	out += projects[0]
	out += "</div>\n\n"

	out += "<div style='border-left: 1px solid #D30000; padding-left: 1rem;'>\n\n"
	out += projects[1]
	out += "</div>\n\n"

	out += "<div style='border-left: 1px solid #D30000; padding-left: 1rem;'>\n\n"
	out += projects[2]
	out += "</div>\n\n"

	out += "<div style='border-left: 1px solid #D30000; padding-left: 1rem;'>\n\n"
	out += projects[3]
	out += "</div>\n\n"

	out += "</div><!-- /rows-5 -->\n\n"
	return out
}
