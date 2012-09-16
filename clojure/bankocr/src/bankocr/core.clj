(ns bankocr.core
  (:require [clojure.string :as string]))

(def codes {
    " _ | ||_|"  0 "     |  |"  1
    " _  _||_ "  2 " _  _| _|"  3
    "   |_|  |"  4 " _ |_  _|"  5
    " _ |_ |_|"  6 " _   |  |"  7
    " _ |_||_|"  8 " _ |_| _|"  9 })

(defn lookup-number [in]
  (get codes (apply str (reduce concat (map #(take 3 %) in)))))

(defn lookup-codes [in]
  (loop [result '()
         codes in]
    (if (empty? (first codes))
      (reverse result)
      (recur (conj result (lookup-number codes))
             (map #(drop 3 %) codes)))))

(defn remove-blanks [codes]
  (filter #(not (string/blank? %)) (string/split codes #"\n")))

(defn parse [in]
  (loop [result '()
         codes (remove-blanks in)]
    (if (empty? codes)
      result
      (recur (conj result (lookup-codes (take 3 codes)))
             (drop 3 codes)))))

(defn verified? [code]
  (and (not (some nil? code))
       (loop [result '()
              c code
              i 0]
         (if (empty? c)
           (not= 0 (mod (reduce + result) 11))
           (recur (cons (* (first c) (+ i 1)) result)
                  (rest c)
                  (inc i))))))

(defn prepare_for_output [code]
  (apply str
         (if (some nil? code)
           (concat (map #(if (nil? %) "?" %) code) [" ILL"])
           (if (verified? code)
             code
             (concat code [" ERR"])))))
