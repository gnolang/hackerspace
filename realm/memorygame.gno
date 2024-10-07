package memorygame

import (
	"std"
	"gno.land/p/demo/avl"
	"gno.land/p/demo/ufmt"
)

var(
	images		   	[]string
	scores 			avl.Tree
)

func init(){
	scores = *avl.NewTree()
	images = []string{
		"https://gno.land/static/img/og-gnoland.png",
	 	"https://schollz.com/img/gno.png",
	 	"https://pbs.twimg.com/media/FmxJDJ_XoAAX27f.jpg:large",
	   	"https://play.gno.land/og-playground-2.png",
	    "https://images.lumacdn.com/cdn-cgi/image/format=auto,fit=cover,dpr=1,background=white,quality=75,width=400,height=400/event-covers/4w/f8751196-bf78-47dc-8879-320198ab8176",
		"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRXK4i0tjkqCBIE19j2E1-v-Eyigybfkanibw&s",
		"https://airdrops.one/wp-content/uploads/2022/04/gno-land-logo.jpeg",
		"https://img.itch.zone/aW1nLzExMjM5OTM1LnBuZw==/original/vD1tZS.png",
		"https://avatars.githubusercontent.com/u/75237105?v=4",
		"https://mythicalcreatures.info/media/gnome-mythical-creatures-1200x900.jpg",
		"https://builtin.com/sites/www.builtin.com/files/styles/ckeditor_optimize/public/inline-images/Blockchain%20Technology.jpg",
		"https://coinbureau.com/_next/image/?url=https%3A%2F%2Fimage.coinbureau.com%2Fstrapi%2FCosmos_Ecosystem_2df2597248.jpg&w=2048&q=50",
		"https://cdn.decrypt.co/wp-content/uploads/2020/01/jae-kwon-gID_1.jpg",
		"https://cdn.hashnode.com/res/hashnode/image/upload/v1659512725142/BlwUf2u16.png", 
		"https://gnoscan.io/gnoscan-thumb.png"}

	// Adding 10 testing scores for different addresses
	scores.Set("address1", 30)
	scores.Set("address2", 25)
	scores.Set("address3", 18)
	scores.Set("address4", 40)
	scores.Set("address5", 35)
	scores.Set("address6", 15)
	scores.Set("address7", 50)
	scores.Set("address8", 22)
	scores.Set("address9", 45)
	scores.Set("address10", 10)
}

func GetSingleImage(index int) string {
	return images[index]
}

func GetImages() []string {
	return images
}

func Register(address std.Address) {
	scores.Set(address.String(), 0)
}

func GetScore(address std.Address) int {
	value, exists := scores.Get(address.String())
	if exists {
		return value.(int)
	} else {
		return -1
	}
}

func SetScore(address std.Address, score int) {
	scores.Set(address.String(), score)
}

func Render(_ string) string {
	out := "<div style='font-family: \"Trebuchet MS\", sans-serif; font-size: 5rem; color: #000000;'>\n\n"
	out += "# Memory Game\n\n"
	out += "</div>\n\n"

	// Game Images section
	out += "<div style='font-family: \"Trebuchet MS\", sans-serif; text-align: justify;'>\n\n"
	for _, img := range images {
		out += "<img src='" + img + "' style='width: 100px; height: 100px; margin: 5px;' />\n"
	}
	out += "</div>"

	// Scoreboard section
	out += "<div style='margin-top: 20px;'>\n"
	out += "<h2 style='font-family: \"Trebuchet MS\", sans-serif;'>Top 5 Scores</h2>\n"

	// Table styling
	out += "<table style='width: 100%; border-collapse: collapse; text-align: center; font-family: \"Trebuchet MS\", sans-serif;'>\n"
	out += "<thead style='; color: white;'>\n"
	out += "<tr>\n"
	out += "<th style='padding: 10px; border: 1px solid #ddd;'>Rank</th>\n"
	out += "<th style='padding: 10px; border: 1px solid #ddd;'>Address</th>\n"
	out += "<th style='padding: 10px; border: 1px solid #ddd;'>Points</th>\n"
	out += "</tr>\n"
	out += "</thead>\n"

	// Table body for top scores
	out += "<tbody>\n"
	topScores := getTopScores(5)
	for i, score := range topScores {
		out += "<tr style='border: 1px solid #ddd;'>\n"
		out += ufmt.Sprintf("<td style='padding: 8px;'>%d</td>\n", i+1)
		out += ufmt.Sprintf("<td style='padding: 8px;'>%s</td>\n", score.address)
		out += ufmt.Sprintf("<td style='padding: 8px;'>%d</td>\n", score.points)
		out += "</tr>\n"
	}
	out += "</tbody>\n"
	out += "</table>\n"
	out += "</div>"

	return out
}


// Helper function to get the top N scores
func getTopScores(n int) []struct{
	address string
	points  int
} {
	var topScores []struct{
		address string
		points  int
	}

	// Reverse iterate through the tree to get the top scores
	scores.ReverseIterate("", "", func(key string, value interface{}) bool {
		topScores = append(topScores, struct {
			address string
			points  int
		}{address: key, points: value.(int)})
		
		// Stop after collecting N scores
		return len(topScores) >= n
	})

	return topScores
}
