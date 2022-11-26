using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BossMovement : MonoBehaviour
{
    public int speed = 1;
    
    void Update()
    {
        if (transform.position.y > 2.5) {
		    transform.Translate(0, -speed * Time.deltaTime, 0);
        }
    }
}
