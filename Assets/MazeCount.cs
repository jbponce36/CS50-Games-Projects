using UnityEngine;
using UnityEngine.UI;
using System.Collections;

[RequireComponent(typeof(Text))]
public class MazeCount : MonoBehaviour {

	private Text text;
	public static int mazeCount = 1;

	// Use this for initialization
	void Start () {
		text = GetComponent<Text>();
	}

	// Update is called once per frame
	void Update () {
		text.text = "Maze: " + mazeCount;
	}
}
