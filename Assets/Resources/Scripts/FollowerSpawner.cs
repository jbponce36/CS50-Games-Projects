using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FollowerSpawner : MonoBehaviour
{   
	public GameObject followerPrefab;
    public GameObject tinyBulletPrefab;
    public List<GameObject> followers = new List<GameObject>();
    public int numberOfFollowers = 0;

    public void SpawnFollower() {
        if (numberOfFollowers > 2) {
            return;
        }

        ClearFollowers();

        numberOfFollowers++;

        for (int i = 0; i < numberOfFollowers; i++) {
            float x = Mathf.Cos(Mathf.PI * 2 * i / numberOfFollowers);
            float y = Mathf.Sin(Mathf.PI * 2 * i / numberOfFollowers);
            Vector2 followerPosition = new Vector2(x, y).normalized * 0.87f;

			GameObject follower = Instantiate (followerPrefab);
			follower.transform.SetParent(GetComponent<Player>().transform);
			follower.transform.localPosition = followerPosition;

            followers.Add(follower);
        }
    }

    void ClearFollowers() {
        for (int i = 0; i < followers.Count; i++) {
            Destroy(followers[i]);
        }

        followers.Clear();
    }

    public void Shoot() {
        for (int i = 0; i < numberOfFollowers; i++) {
            Instantiate(tinyBulletPrefab, followers[i].transform.position, followers[i].transform.rotation);
        }
    }

    public void LoseFollower() {
        if (numberOfFollowers > 0) {
            numberOfFollowers -= 2;
            SpawnFollower();
        }
    }
}
