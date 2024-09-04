package home

import (
	"gno.land/r/nemanya/config"
)

type Project struct {
	Name 				string
	URL  				string
}

type Social struct {
	Name 				string
	URL  				string
}

var (
	aboutMe   			string
	projects  			map[int]Project
	socials   			map[int]Social


	fontFamily 			= "Inter, sans-serif"
	primaryColor 		= "#FEFEFE"
	borderColor 		= "#D30000"
	fontSizeLarge 		= "7rem"
	fontSizeMedium 		= "4rem"
	fontSizeSmall 		= "1.5rem"
	fontSizeExtraSmall 	= "1rem"
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
	return "<div style='display: flex;'>\n" +
		"  <div style='flex: 8; margin-right: 20px; padding: 2rem; border: 2px solid transparent; border-image: linear-gradient(166deg, " + borderColor + " 0%, rgba(0,0,0,0) 20%); border-image-slice: 1;'>\n" +
		"    " + renderAboutMe() + "\n" +
		"  </div>\n" +
		"  <div style='flex: 2; padding: 2rem; border: 2px solid transparent; border-image: linear-gradient(324deg, " + borderColor + " 0%, rgba(0,0,0,0) 20%); border-image-slice: 1;'>\n" +
		"    " + renderProjects() + "\n" +
		"  </div>\n" +
		"</div>\n"
}

func renderAboutMe() string {
	return "<div class='rows-3'>\n" +
		"  <h1 style='font-family: " + fontFamily + "; font-weight: 100; color: " + primaryColor + "; text-align: left; font-size: " + fontSizeLarge + ";'>Nemanya.</h1>\n" +
		"  <div style='border-left: 1px solid " + borderColor + "; padding-left: 1rem;'>\n" +
		"    <p style='font-family: " + fontFamily + "; color: " + primaryColor + "; font-size: " + fontSizeSmall + "; margin-bottom: 5rem;'>\n" +
		"      " + aboutMe + "\n" +
		"    </p>\n" +
		"  </div>\n" +
		"  " + renderSocials() + "\n" +
	"</div><!-- /rows-3 -->\n"
}

func renderSocials() string {
	socialsHTML := "<div class='socials-container' style='display: flex; justify-content: center; align-items: center; gap: 20px;'>\n"
	for _, social := range socials {
		socialsHTML += "  <div style='display: flex; justify-content: center; align-items: center;'>\n" +
			"    <a href='" + social.URL + "' style='color: " + primaryColor + "; font-family: " + fontFamily + "; font-size: " + fontSizeExtraSmall + "; display: flex; justify-content: center; align-items: center; width: 100%; height: 100%;'>" + social.Name + "</a>\n" +
			"  </div>\n"
	}
	socialsHTML += "</div>\n"
	return socialsHTML
}

func renderProjects() string {
	projectsHTML := "<div class='rows-5'>\n" +
		"  <h2 style='font-family: " + fontFamily + "; font-weight: 200; color: " + primaryColor + "; text-align: left; font-size: " + fontSizeMedium + ";'>Projects</h2>\n"
	for _, project := range projects {
		projectsHTML += "  <div style='margin-bottom: 1rem; border-left: 1px solid " + borderColor + "; padding-left: 1rem;'>\n" +
			"    <a href='" + project.URL + "' style='color: " + primaryColor + "; font-family: " + fontFamily + "; font-size: " + fontSizeSmall + ";'>" + project.Name + "</a>\n" +
			"  </div>\n"
	}
	projectsHTML += "</div><!-- /rows-5 -->\n"
	return projectsHTML
}
