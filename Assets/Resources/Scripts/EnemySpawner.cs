using UnityEngine;
using System.Collections;

public class EnemySpawner : MonoBehaviour {

	public GameObject[] prefabs;
	public bool spawnEnemies = true;
	public GameObject bossPrefab;
	public float spawnBossAfterSeconds = 60f;
	public static float addedSpeed = 0f;
	public static int addedHealth = 0;

	void Start () {
		addedSpeed = 0f;
		addedHealth = 0;
		StartCoroutine(SpawnEnemies());
		StartCoroutine(SpawnBoss());
	}

	IEnumerator SpawnEnemies () {
		while (spawnEnemies) {
			SpawnRandomWave();
			yield return new WaitForSeconds(Random.Range(2.5f, 4f));
		}
	}

	void SpawnRandomWave() {
		int randomEnemyType = Random.Range(0, prefabs.Length);
		int randomEnemyAmount = Random.Range(1, 5);
		float interval = (4 / randomEnemyAmount);
		
		float flipDirection = 1f;
		if (Random.Range(0, 2) == 0) {
			flipDirection = (-1f);
		}
		
		for (int i = 0; i < randomEnemyAmount; i++) {
			GameObject enemy = Instantiate(prefabs[randomEnemyType], new Vector3(Random.Range(-2f + i * interval, -2f + (i + 1f) * interval), transform.position.y, 0), Quaternion.identity);
			enemy.GetComponent<EnemyMovement>().verticalSpeed += addedSpeed;
			enemy.GetComponent<EnemyMovement>().horizontalDirection *= flipDirection;
			enemy.GetComponent<Enemy>().health += addedHealth;
			
			EnemyWeapon enemyWeapon = enemy.GetComponent<EnemyWeapon>();
			if (enemyWeapon != null) {
				enemyWeapon.addedSpeed += addedSpeed;
			}
		}

		addedSpeed += 0.1f;
		addedHealth += 20;
	}

    IEnumerator SpawnBoss () {
        yield return new WaitForSeconds(spawnBossAfterSeconds);

        spawnEnemies = false;
		yield return new WaitForSeconds(3f);

        Instantiate (bossPrefab);
    }
}
