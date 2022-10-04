using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class DespawnOnHeight : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (transform.position.y <= -2f) {
            DontDestroy.instance.GetComponents<AudioSource>()[0].Stop();
			SceneManager.LoadScene("Game Over");
		}
    }
}
