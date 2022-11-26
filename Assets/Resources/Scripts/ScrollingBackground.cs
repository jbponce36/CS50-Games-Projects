using UnityEngine;
using System.Collections;

public class ScrollingBackground : MonoBehaviour {

	public float scrollSpeed;
	public Renderer rend;
	public float height;
	public float startPosition;

	void Start () {
		rend = GetComponent<Renderer>();
		height = rend.bounds.size.y;
		startPosition = transform.position.y;
	}

	void Update () {
		if (!PauseMenu.gamePaused) {
			float offset = scrollSpeed;

			transform.position = transform.position + new Vector3(transform.position.x, -offset, 0);

			if (transform.position.y <  startPosition - height) {
				transform.position = new Vector3(transform.position.x, startPosition, 0);
			}
		}
	}
}
