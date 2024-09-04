package home

import (
	"gno.land/r/nemanya/config"
)

type Project struct {
	Name string
	URL  string
}

type Social struct {
	Name string
	URL  string
}

var (
	aboutMe  string
	projects map[int]Project
	socials  map[int]Social
)

func init() {
	aboutMe = "I'm Nemanja Matic from Serbia, an IT student and aspiring Web3 developer. I discovered gno.land at the Petnica Web3 Camp and I'm eager to make significant contributions to this project."

	projects = map[int]Project{
		0: {"Liberty Bridge", "https://github.com/Milosevic02/LibertyBridge"},
	}

	socials = map[int]Social{
		0: {"GitHub", "https://github.com/Nemanya8"},
		1: {"LinkedIn", "https://www.linkedin.com/in/nemanjamatic"},
		2: {"Email", "mailto:matic.nemanya@gmail.com"},
	}
}

func UpdateAboutMe(newAboutMe string) {
	config.AssertAuthorized()
	aboutMe = newAboutMe
}

func AddProject(index int, name string, url string) {
	config.AssertAuthorized()
	if index >= 0 && index < 4 {
		projects[index] = Project{Name: name, URL: url}
	}
}

func RemoveProject(index int) {
	config.AssertAuthorized()
	if index >= 0 && index < 4 {
		delete(projects, index)
	}
}

func AddSocial(index int, name string, url string) {
	config.AssertAuthorized()
	if index >= 0 && index < 3 {
		socials[index] = Social{Name: name, URL: url}
	}
}

func RemoveSocial(index int) {
	config.AssertAuthorized()
	if index >= 0 && index < 3 {
		delete(socials, index)
	}
}

func Render(path string) string {
	out := "<div style='display: flex;'>\n\n"

	out += "<div style='flex: 8; margin-right: 20px; padding: 2rem; border: 2px solid transparent; border-image: linear-gradient(166deg, rgba(211,0,0,1) 0%, rgba(0,0,0,0) 20%); border-image-slice: 1;'>"
	out += renderAboutMe()
	out += "</div>"

	out += "<div style='flex: 2; padding: 2rem; border: 2px solid transparent; border-image: linear-gradient(324deg, rgba(211,0,0,1) 0%, rgba(0,0,0,0) 20%); border-image-slice: 1;'>"
	out += renderProjects()
	out += "</div>\n\n"

	out += "</div>\n\n"
	return out
}

func renderAboutMe() string {
	out := "<div class='rows-3'>"
	out += "<h1 style='font-family: Inter, sans-serif; font-weight: 100; color: #FEFEFE; text-align: left; font-size: 7rem;'>Nemanya.</h1>"
	out += "<div style='border-left: 1px solid #D30000; padding-left: 1rem;'>"
	out += "<p style='font-family: Inter, sans-serif; color: #FEFEFE; font-size: 1.5rem; margin-bottom: 5rem;'>"
	out += aboutMe
	out += "</p>\n\n"
	out += "</div>\n\n"

	out += renderSocials()
	out += "</div><!-- /rows-3 -->\n\n"
	return out
}

func renderSocials() string {
	out := "<div class='socials-container' style='display: flex; justify-content: center; align-items: center; gap: 20px;'>\n\n"
	for _, social := range socials {
		out += "<div style='display: flex; justify-content: center; align-items: center;'>"
		out += "<a href='" + social.URL + "' style='color: #FEFEFE; font-family: Inter, sans-serif; font-size: 1rem; display: flex; justify-content: center; align-items: center; width: 100%; height: 100%;'>" + social.Name + "</a>"
		out += "</div>\n"
	}
	out += "</div>\n\n"
	return out
}

func renderProjects() string {
	out := "<div class='rows-5'>"
	out += "<h2 style='font-family: Inter, sans-serif; font-weight: 200; color: #FEFEFE; text-align: left; font-size: 4rem;'>Projects</h2>"
	for _, project := range projects {
		out += "<div style='margin-bottom: 1rem; border-left: 1px solid #D30000; padding-left: 1rem;'>"
		out += "<a href='" + project.URL + "' style='color: #FEFEFE; font-family: Inter, sans-serif; font-size: 1.5rem;'>" + project.Name + "</a>"		
		out += "</div>\n"
	}
	out += "</div><!-- /rows-5 -->\n\n"
	return out
}
