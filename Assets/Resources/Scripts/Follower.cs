using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Follower : MonoBehaviour
{
    public GameObject target;
    public float rotationSpeed = 60f;

    void Start () {
        target = GameObject.FindGameObjectWithTag("Player");
    }

    void Update()
    {
        // Spin the object around the target at rotationSpeed degrees/second.
        transform.RotateAround(target.transform.position, Vector3.forward, rotationSpeed * Time.deltaTime);
        transform.rotation = Quaternion.Euler(0, 0, 0);
    }
}
