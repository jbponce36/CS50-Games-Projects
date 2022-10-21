using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StarGoal : MonoBehaviour
{
    public bool showText = false;

    void OnTriggerEnter(Collider other) {
        showText = true;
	}
}
