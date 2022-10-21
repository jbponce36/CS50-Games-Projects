using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using System.Collections;

public class YouWonText : MonoBehaviour {

    public GameObject starGoal;
	private Text text;

	// Use this for initialization
	void Start () {
		text = GetComponent<Text>();

		// start text off as completely transparent black
		text.color = new Color(0, 0, 0, 0);
	}

    // Update is called once per frame
	void Update () {
		if (starGoal.GetComponent<StarGoal>().showText) {
            
            // change text color to orange
			text.color = new Color(1f, 105f / 255f, 0f, 1f);
            text.text = "You won!\nPress Return to Restart!";
            
            if (Input.GetButtonDown("Submit")) {

                // reload entire scene
                SceneManager.LoadScene("New Level");
            }
		}
	}
}
