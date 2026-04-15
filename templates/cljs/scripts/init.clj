#!/usr/bin/env bb

(ns init
  (:require
   [clojure.string :as str]
   [babashka.fs :as fs]
   [clojure.java.shell :refer [sh]]))

(defn already-initialized? []
  (not (fs/exists? "src/__NS__")))

(defn project-name []
  (-> (fs/cwd)
      fs/file-name
      str))

(defn prompt [s]
  (print s)
  (flush)
  (read-line))

(defn valid-ns? [ns]
  (boolean
   (re-matches
    #"^[a-zA-Z][a-zA-Z0-9\-]*(\.[a-zA-Z][a-zA-Z0-9\-]*)*$"
    ns)))

(defn ns->path [ns]
  (-> ns
      (str/replace "." "/")
      (str/replace "-" "_")))

(defn replace-in-files [root replacements]
  (doseq [f (fs/glob root "**.{clj,cljs,edn,json,md}")]
    (let [fstr (str f)]
      (when (fs/regular-file? f)
        (let [content (slurp fstr)
              new-content (reduce
                           (fn [acc [k v]]
                             (str/replace acc k v))
                           content
                           replacements)]
          (when (not= content new-content)
            (spit fstr new-content)))))))


(defn move-src [ns-path]
  (let [from (fs/path "src" "__NS__")
        to   (fs/path "src" ns-path)]
    (when (fs/exists? from)
      (when (fs/exists? to)
        (println "Target already exists:" to)
        (System/exit 1))
      (fs/create-dirs (fs/parent to))
      (fs/move from to))))

(defn -main []
  (when (already-initialized?)
    (println "Project already initialized.")
    (System/exit 1))

  (let [ns (prompt "Enter ClojureScript namespace (e.g. my.cool-project): ")]
    (when-not (valid-ns? ns)
      (println "Invalid namespace")
      (System/exit 1))

    (let [ns-path (ns->path ns)
          project-name (project-name)]

      ;; 👇 RIGHT HERE
      (when (or (nil? project-name)
                (= project-name ""))
        (println "Could not determine project directory name")
        (System/exit 1))

      (let [replacements {"__NS__" ns
                          "__PROJECT_NAME__" project-name}]

        (replace-in-files "." replacements)
        (move-src ns-path)

        (println "✔ Namespace:" ns)
        (println "✔ Project name:" project-name)
        (println "✔ Path: src/" ns-path)))))

(-main)
